require 'rubygems'
require 'active_support/all'
require 'net/http'
require 'rufus-scheduler'
require 'mechanize'
require 'fileutils'
require 'logger'
require 'active_record'
require 'open-uri'
require 'json'

ROOT = Dir.pwd

load 'config/setting.rb'

Dir.glob("#{ROOT}/app/*.rb"){|m| require m}
Dir.glob("#{ROOT}/app/models/*.rb"){|m| require m}

# Main.run
#('pechenev', '456zxc369')


#DbSaver.run(Date.today)
#scrapper = TFScraper.new
#scrapper.run

Scrapper.run
Html2json.run