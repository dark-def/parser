class DbSaver

  def self.run(date)
    @m = Mechanize.new()
    save_tracks_and_races(date)
  end

  def self.file2mechanize(path)
    path.insert(0, 'file://')
    @m.get(path)
  end

  def self.save_tracks_and_races(date)
    path =  File.expand_path("./TF_DIR/#{date}/races.html")
    page = file2mechanize(path)
    data = page.parser.css("table[border='0'][width='100%']")
    unless data.text.include?('SUMMARY') && data.text.include?(date.strftime("%d/%m/%y"))
      raise "Wrong data for tracks!"
    end

    track = nil
    track_path = nil

    data.css('tr').each do |tr|
      p "race" + "-"*100
      trdata = tr.css('td')

      if trdata.count == 2
        track_path = trdata.css('.style16mb:first').text.match(/\A(.+?)SUMMARY/)
        track_path = Scrapper.to_valid_name(track_path[1]) if track_path
        track_title = trdata.css('.style16mb:first').text.match(/\A(.+?)\s{2,}/)
        track = Track.find_or_create_by_title(:title => track_title[1]) if track_title
      elsif trdata.count == 5
        unless trdata[2].css('a').count == 0
          time = Scrapper.to_valid_name(trdata[0].text)
          hm = time.match(/\A(\d{1,2})_(\d{2})\z/)
          zone = DateTime.now.zone
          datetime = DateTime.parse("#{Date.today} #{hm[1].to_i+12}:#{hm[2]} #{zone}") if hm
          number = Scrapper.to_valid_name(trdata[1].text)
          title = Scrapper.to_valid_name(trdata[2].text)
          raw_distance = trdata[4].text
          if track
            race = Race.find_or_create_by_title_and_datetime_and_track_id(:track_id => track.id, :number => number, :title => title, :raw_distance => raw_distance, :datetime => datetime)
            p "  save ---> #{race.title}"
            download_runners(date, time, race, track_path)
          end
        end
      end
    end
  end

  def self.download_runners(date, time, race, track_path)
    path =  File.expand_path("./TF_DIR/#{date}/#{track_path}/#{time}_#{race.title}/#{time}_#{race.title}.html")
    page = file2mechanize(path)
    runner = {}
    page.parser.css('table').each do |table|
      if table.text.include?('RATING') && table.text.include?('BETFAIR BACK') && table.css('table').count == 0
        table.css('tr').each do |tr|
          runner_data = tr.css('td')
          if runner_data.count == 11
            p " "*5 + "runner" + "-"*20
            runner['form'] = runner_data[0].text
            runner['name'] = runner_data[2].text
            if img = runner_data[2].css('img')
              img.map do |i|
                if i.attributes['title'].value == 'Horses In Focus are selected by the Timeform team as being worth noting on their next outing'
                  runner['hif'] = i.attributes['title'].value
                elsif i.attributes['title'].value == 'Course Winner'
                  runner['cw'] = i.attributes['title'].value
                end
              end
            end
            runner['age'] = runner_data[3].text
            runner['weight'] = runner_data[4].text
            runner['eq'] = runner_data[5].text
            runner['jockey'] = runner_data[6].text
            runner['rating'] = runner_data[7].text
            runner['in_play_symbols'] = runner_data[8].text
            runner['betfair_back'] = runner_data[9].text
            runner['betfair_lay'] = runner_data[10].text
          elsif tr.css('td').count == 4
            runner['no_draw'] = runner_data[0].text
            runner['trainer'] = runner_data[2].text
            runner.each {|key, val| runner[key] = to_valid_name(val)}
            #p '+'*50
            #p runner
            run = Runner.find_or_create_by_name_and_race_id(
              :race_id => race.id,
              :form => runner['form'],
              :name => runner['name'],
              :hif => runner['hig'],
              :cw => runner['cw'],
              :age => runner['age'],
              :weight => runner['weight'],
              :eq => runner['eq'],
              :jockey => runner['jockey'],
              :rating => runner['rating'],
              :in_play_symbols => runner[',in_play_symbols'],
              :betfair_back => runner['betfair_back'],
              :betfair_lay => runner['betfair_lay'],
              :no_draw => runner['no_draw'],
              :trainer => runner['trainer']
            )
            p " "*6 + "save ---> #{run.name}"
            runner = {}
          end
        end
      end
    end
  end

  def self.to_valid_name(name)
    name.lstrip.rstrip.gsub(/\s+/, ' ')
  end
end