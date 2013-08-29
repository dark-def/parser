class ParseController < ApplicationController
  require 'rubygems'
  require 'selenium-webdriver'
  require 'nokogiri'
  require 'open-uri'

  def save(target)

  end

  def get_post
    driver = Selenium::WebDriver.for :firefox
    driver.manage.window.maximize
    driver.get 'http://faceit-team.com/'

    driver.find_element(:xpath, '/html/body/div/div/header/div/ul/li[5]/a').click
    #driver.find_element(:xpath, '/html/body/div/div/div[2]/div/ul/li[3]/a').click         #ruby on rails
    #driver.find_element(:xpath, '/html/body/div/div/div[2]/div[2]/div/div[2]/div[5]/h2/a').location_once_scrolled_into_view
    #driver.find_element(:xpath, '/html/body/div/div/div[2]/div[2]/div/div[2]/div[5]/h2/a').click
    doc = Nokogiri::HTML(driver.page_source)
    @link = Array.new
    @posts = Hash.new
    doc.css('div.post a').each_with_index do |link, index|
      @link[index] = link#['href']
    end

    @link.each do |l|
      #post = Nokogiri::HTML(l)                     #get source of page
      driver.find_element(:tag_name, "#{l}").click          #try to find link on page and click on it
      element_title = find_element(:xpath, '/html/body/div/div/div[2]/div[2]/div/h2').text             #try to find title
      element_body = find_element(:xpath, '/html/body/div/div/div[2]/div[2]/div').text                 #and body of post
      @posts = {:title => element_title, :body => element_body }                                        #and recording it to hash
    end

    render 'product/index'
    #page.css('div#reference a')
  end

end

#/html/body/div/div/div[2]/div[2]/div/div[2]/div/h2