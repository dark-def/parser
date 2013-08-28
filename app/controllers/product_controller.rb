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

    driver = Selenium::WebDriver.for :firefox
    driver.manage.window.maximize
    driver.get 'http://faceit-team.com/'

    doc = Nokogiri::HTML(driver.page_source)
    @images = Array.new

    doc.css("img").each_with_index do |item, index|
      @images[index] = item['src']
    end
    #element.location_once_scrolled_into_view
    driver.find_element(:xpath, '/html/body/div/div/header/div/ul/li[5]/a').click
    driver.find_element(:xpath, '/html/body/div/div/div[2]/div/ul/li[3]/a').click
    driver.find_element(:xpath, '/html/body/div/div/div[2]/div[2]/div/div[2]/div[5]/h2/a').location_once_scrolled_into_view
    driver.find_element(:xpath, '/html/body/div/div/div[2]/div[2]/div/div[2]/div[5]/h2/a').click
    doc = Nokogiri::HTML(driver.page_source)
    @post = doc.xpath('/html/body/div/div/div[2]/div[2]/div')
    #@post = driver.find_element(:class, 'post')
    #element = driver.find_element(:name, 'text')
    #element.send_keys 'http://faceit-team.com/'
    #element.submit


    #element = driver.find_element(:id, "coolestWidgetEvah")
    #link = driver.find_element(:xpath, '/html/body/div[2]/div[2]/div/div[2]/ol/li/h2/a')
    #link.click
    #driver.find_element(:partial_link_text, 'Knowledge').click
    #element.click
    #element = driver.find_element(:link_text, 'Ruby on Rails FAQ')
    #element.click.find_element(:link, 'Ruby on Rails FAQ')

    puts driver.title
    #b-serp-list i-bem b-serp-list_js_inited
    #element = driver.find_element(:li)

    driver.quit


    #doc = Nokogiri::HTML(driver.page_source)
    #@logo = doc.css('hplogo')
    #doc.css("img").each_with_index do |item, index|
    #  @images[index] = item['src']
    #end
  end
end
