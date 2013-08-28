class ProductController < ApplicationController
  require 'rubygems'
  require 'selenium-webdriver'
  require 'nokogiri'
  require 'open-uri'

  def index
  end

  def show
  end

  def delete
  end

  def parse



    driver = Selenium::WebDriver.for :firefox
    driver.manage.window.maximize
    driver.get 'http://faceit-team.com/'

    doc = Nokogiri::HTML(driver.page_source)
    @images = Array.new

    doc.css("img").each_with_index do |item, index|
      @images[index] = item['src']
    end

    driver.find_element(:xpath, '/html/body/div/div/header/div/ul/li[5]/a').click
    driver.find_element(:xpath, '/html/body/div/div/div[2]/div/ul/li[3]/a').click         #ruby on rails
    driver.find_element(:xpath, '/html/body/div/div/div[2]/div[2]/div/div[2]/div[5]/h2/a').location_once_scrolled_into_view
    driver.find_element(:xpath, '/html/body/div/div/div[2]/div[2]/div/div[2]/div[5]/h2/a').click
    doc = Nokogiri::HTML(driver.page_source)
    @post = doc.xpath('/html/body/div/div/div[2]/div[2]/div')

    driver.find_element(:xpath, '/html/body/div/div/header/div/ul/li[5]/a').click         #ruby on rails
    driver.find_element(:xpath, '/html/body/div/div/div[2]/div[2]/div/div[2]/div[6]/h2/a').location_once_scrolled_into_view
    driver.find_element(:xpath, '/html/body/div/div/div[2]/div[2]/div/div[2]/div[6]/h2/a').click
    doc = Nokogiri::HTML(driver.page_source)
    @post2 = doc.xpath('/html/body/div/div/div[2]/div[2]/div')

    puts driver.title

    driver.quit

  end

  def circle_parse

    driver = Selenium::WebDriver.for :firefox
    driver.manage.window.maximize
    driver.get 'http://faceit-team.com/'

    #driver.find_element(:xpath, '/html/body/div/div/header/div/ul/li[5]/a').click
    #driver.find_element(:xpath, '/html/body/div/div/div[2]/div/ul/li[3]/a').click         #ruby on rails

    #int numberOfElementsFound = getNumberOfElementsFound(locator);
    #for (int pos = 0; pos < numberOfElementsFound; pos++) {
    #    getElementWithIndex(locator, pos).click();
    #}

    doc = Nokogiri::HTML(driver.page_source)
    driver.find_elements(:tag_name, "a").each {|link| link.click }
    #links = driver.find_elements(:tag_name, 'a').count
    #links.each do |l|
    #  l.click
    #end

    render :parse

  end

end
