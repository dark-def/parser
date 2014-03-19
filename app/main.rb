class Main

  #@@monitor = Rufus::Scheduler.start_new
  #
  #def self.run
  #   @@monitor.every '1s' do
  #     print '.'
  #   end
  #   @@monitor.cron "0 0 8 * * *", :blocking => true do
  #     action_time{check}
  #   end
  #   @@monitor.in '1s', :blocking => true do
  #     action_time{check}
  #   end
  #   @@monitor.join
  #end

  # def self.check
  #   FileUtils.makedirs("./TF_DIR/#{Date.today.to_s}")
  #   if File.exists?("./TF_DIR/#{Date.today.to_s}/races.html")
  #     puts 'Data for today already downloaded' + '-'*50
  #   else
  #       Scrapper.run
  #       DbSaver.run(Date.today)
  #   end
  # end

  # def self.action_time
  #   start_time = Time.now
  #   yield
  #   p "ACTION TIME: #{Time.now - start_time}"
  # end

end