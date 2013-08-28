class ProductController < ApplicationController
  def index
  end

  def show
  end

  def delete
  end

  def parse

    require 'selenium-webdriver'
    require 'nokogiri'
    require 'open-uri'

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
end
