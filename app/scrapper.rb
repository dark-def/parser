class Scrapper

  def self.run
    @browser = Mechanize.new
    @browser.user_agent_alias = 'Mac Safari'
    @repeats = 0
    auth
    download_public
    #races
  end

  def self.download_public
    date = '2014-01-01'.to_date
    while date <= Date.today do
      p date.to_s
      page = @browser.get("https://www.timeform.com/Racing/Results/ArchiveFormListForDay?MeetingDate=#{date.to_s}")
      page.search('tr').each do |tr|
        next if tr.search('td').length < 2
        text = to_valid_name(tr.search('td')[1].text).truncate(100)
        link = tr.search('td')[0].search('a').attr('href').value if tr.search('td')[0].search('a').length > 0
        full_link = "https://www.timeform.com#{link}"
        doc = Nokogiri::HTML(open(full_link))
        write_to_folder(date, text, doc, 'races')  # write date races
        page = @browser.get(full_link)
        page.search('.fw.tblCustom').search('tbody').each do |tr|
          horse_name = tr.search('td')[2].children.children.text
          horse_link = tr.search('td')[2].children.attr('href').value if tr.search('td')[2].children.attr('href') != nil
          write("races/#{date}/runners", horse_name, horse_link)     # write date horses
        end
      end
      date += 1.day
    end
  end

  def self.auth
    if @repeats < 2
      account = get_account
      puts account

      login(account['account'], account['password'])
    else
      raise('Login is failed and sign up is failed. Maybe you was banned.')
    end
  end

  def self.login(user,pass)
    puts "Calling login #{user} #{pass}"
    page = @browser.get('https://www.timeform.com/Racing/')
    form = page.form_with(:id => "form0")
    form["EmailAddress"] = user
    form["Password"] = pass
    form.submit
    sleep(2)
    verify_login
  end

  def self.verify_login
    page = @browser.get('https://www.timeform.com/Racing/Account/Manage').body
    p page.include?('<h2>Manage Your Timeform Account</h2>') ? 'Logged in' : 'FAILED TO LOGIN TO TF'    #  F
    #sign_up
    #raise 'FAILED TO LOGIN TO TF'
  end

  def self.sign_up
    # raise "ERROR"
    puts 'sign_up'
    @browser = Mechanize.new
    @browser.user_agent_alias = 'Mac Safari'

    uid = id_generate

    user = "jack.v#{uid}"
    email = "#{user}@gmail.com"
    password = "Password123"

    page = @browser.post('https://www.timeform.com/member_add.asp?retry=0', {
        'prefix' => '',
        'forename' => "Jack",
        'surname' => "Vorobey#{uid}",
        'suffix' => '',
        'address1' => 'Rockhill',
        'address2' => 'Loughton',
        'address3' => '',
        'address4' => '',
        'address5' => '',
        'postcode' => 'IG103TZ',
        'telephone' => '812335123',
        'email' => email,
        'login' => user,
        'password' => password,
        'checkpassword' => password,
        'country' => "1",
        'enterdetails' => 'Submit'
    })

    # puts page.body

    write_account(user, password)
    @repeats += 1
    #File.open("./TF_DIR/test.html", 'w'){|f| f.write  page.body}
    auth
  end

  def self.write_account(acc, pass)
    result = JSON.parse(open("./TF_DIR/accounts.json").read)
    result = {:account => acc, :password => pass}
    File.open("./TF_DIR/accounts.json","w") do |f|
      f.write(JSON.pretty_generate(result))
    end
  end

  def self.get_account
    result = JSON.parse(open("./TF_DIR/accounts.json").read)
    result
  end

  def self.id_generate
    Time.now.to_i
  end

  def self.races
    page = @browser.get("https://www.timeform.com/timed_subscribe_process.asp?days=1&cost=0")
    page_valid(page)
    track = nil
    page.links.each do |l|
      if l.href =~ /http:\/\/www.timeform.com\/timed_daily_confirm.asp/ && !l.href.include?('99')
        l.attributes.parent.parent.children.each do |td|
          if td.text =~ /\A\d{1,2}\.\d{2}\z/
            race_time = td.text
            to_race(l, track, race_time)
          end
        end
      elsif l.href =~ /http:\/\/www.timeform.com\/timed_daily_confirm.asp/ && l.href.include?('99')
        track = to_summary(l)
      end
    end
    write(Date.today.to_s, 'races', page.body)
  end

  def self.to_summary(link)
    page = link.click
    file_name = page.parser.css('.style17m').text
    file_name = to_valid_name(file_name[0, file_name.index('OFFICIAL')-3])
    write("#{Date.today.to_s}/#{file_name}", file_name + "_SUMMARY", page.body)
    file_name
  end

  def self.to_race(link, track, race_time)
    page = link.click
    page_valid(page)
    p "#{race_time}-#{link.text}"
    race = to_valid_name("#{race_time}-#{link.text}")
    write("#{Date.today.to_s}/#{track}/#{race}", race, page.body)
    page.links.each do |l|
      if l.href =~ /javascript:openScript\('timed_horse_form\.asp\?code=/
        to_runner(race, l, track)
      end
    end
  end

  def self.to_runner(race, link, track)
    url = link_generate(link.href)
    #p "URL --->> #{url}"
    page = @browser.get(url)
    page_valid(page)
    if page.body.include?("Unfortunately there appears to be a problem with the page you were trying to view or the information you wish to access.")
      raise 'Wrong arguments!!!'
    end
    runner = to_valid_name(link.text)
    write("#{Date.today.to_s}/#{track}/#{race}/runners", runner, page.body)
  end

  def self.link_generate(link)
    "http://www.timeform.com/timed_horse_form.asp?code=#{get_url_param(link,'code')}&season=#{get_url_param(link,'season')}&adj=#{get_url_param(link,'adj')}&rating=#{get_url_param(link,'rating')}&symbol=#{get_url_param(link,'symbol')}&masterirs=#{get_url_param(link,'masterirs')}&service=#{get_url_param(link,'service')}&runlimit=#{get_url_param(link,'runlimit')}"
  end

  def self.get_url_param(url, param)
    m = url.match("#{param}=(.*?)[&']")
    m[1]
  end

  def self.page_valid(page)
    unless page.code.to_i == 200
      raise "Invalid result code"
    end
  end

  def self.to_valid_name(name)
    name.gsub(/[\W]+?/, ' ').lstrip.rstrip.gsub(/\s+/, '_')
  end

  def self.write(path, filename, data)
    FileUtils.makedirs("./TF_DIR/#{path}")
    file_path = "./TF_DIR/#{path}/#{filename}.html"
    if !File.exists?(file_path)
      File.open(file_path, 'w'){|f| f.write  data}
      p "WRITE... ----> #{file_path}"
    else
      p "Already exist ----> #{file_path}"
    end
  end

  def self.write_to_folder(path, filename, data, folder)
    FileUtils.makedirs("./TF_DIR/#{folder}/#{path}/")
    file_path = "./TF_DIR/#{folder}/#{path}/#{filename}.html"
    if !File.exists?(file_path)
      File.open(file_path, 'w'){|f| f.write  data}
      p "WRITE... ----> #{file_path}"
    else
      p "Already exist ----> #{file_path}"
    end
  end

end