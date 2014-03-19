class Html2json

  class << self

    def run
      all_races = enter('./TF_DIR/races')
      hash_to_write = {}
      hash_to_write[:races] = {}
      Dir.foreach(all_races) do |file|                                  # iterate all files in folder
        if File.directory?(file) && !(file =~ /^([.]|[..])+/)           # if file is folder and it is not . or ..
          day_races = enter(file)                                       # enter this folder
          Dir.foreach(day_races) do |race|                              # and iterate all files
            if !(File.directory?(race)) && race =~ /.html$/             # if file in folder is not directory and it is .html
              race_hash = race_details_from_file(race)                  # open him and save to db
              if race_hash == false
                next
              end
              hash_to_write[:races].merge!(race_hash)
              File.open("#{file}-races.json", 'w'){|f| f.write (hash_to_write.to_json)}
            end
          end
          exit
        else
          p "#{file} IS NOT A FOLDER"
        end
      end
    end

    private

    def enter(dir)
      Dir.chdir(dir)
      return Dir.pwd
    end

    def exit
      Dir.chdir('..')
      return Dir.pwd
    end

    def race_details_from_file(file)
      page = Nokogiri::HTML(open(file))

      if page.content.include?('The site is currently closed for maintenance and should be back by 12:00 GMT')
        return false
      end

      race_name = page.xpath('/html/body/div/div/div[2]/div/div/article/article/header/h2').text.gsub(/Full Result/, '').strip
      date = race_name.match(/\d{2}\/\d{2}\/\d{4}/)[0] if race_name != nil

      sub_table = page.css('table.fw')[0] if page.css('table.fw')[0] != nil
      number = sub_table.css('tr')[0].css('td')[0].text.match(/Race \d/)[0] if sub_table != nil
      distance = sub_table.css('td.ar')[0].children[1].text if sub_table != nil
      going = sub_table.css('td.ar')[1].children[1].text if sub_table != nil
      prize = sub_table.css('tr')[1].css('td')[0].children[1].text if sub_table != nil
      age = sub_table.css('tr')[1].css('td')[0].children[5].text if sub_table.css('tr')[1].css('td')[0].children[5] != nil

      #created_race = Race.create(:number => number, :title => race_name, :distance => distance, :going => going, :prize => prize, :age => age, :datetime => date.to_date)

      races_today = {
          :date => date,
          number => {}
      }

      race = {
          :race_name => race_name,
          :date => date,
          :number => number,
          :distance => distance,
          :going => going,
          :prize => prize,
          :age => age,
          :runners => {}
      }

      tbody = page.xpath('/html/body/div/div/div[2]/div/div/article/table/tbody')
      tbody.css('tr').each_with_index do |tr, index|
        pos = tr.css('td')[0].text.strip
        btn = tr.css('td')[1].text.strip
        horse = tr.css('td')[2].text.strip
        tfr = tr.css('td')[5].text.gsub(/\s+\\r\\n$/, '').strip
        age = tr.css('td')[7].text.strip
        wgt = tr.css('td')[8].text.strip
        eq = tr.css('td')[9].text.strip
        trainer = tr.css('td')[10].text.strip
        jockey = tr.css('td')[11].text.strip
        isp = tr.css('td')[12].text.strip
        bsp = tr.css('td')[13].text.strip
        hilo = tr.css('td')[14].try(:text)

        runner = {
            "#{index}" => {
              :pos => pos,
              :btn => btn,
              :horse => horse,
              :tfr => tfr,
              :age => age,
              :wgt => wgt,
              :eq => eq,
              :trainer => trainer,
              :jockey => jockey,
              :isp => isp,
              :bsp => bsp,
              :hilp => hilo
            }
        }

        race[:runners].merge!(runner)

        #Runner.find_or_create_by(:pos => pos, :btn => btn, :name => horse, :tfr => tfr, :age => age, :weight => wgt, :eq => eq,
        #             :trainer => trainer, :jockey => jockey, :isp => isp, :bsp => bsp, :hilo => hilo, :race_id => created_race.id )


      end
    races_today[number].merge!(race)
    #pp races_today

    puts "file ---- > #{file} successfuly saved!"
    return races_today
    end

  end

end