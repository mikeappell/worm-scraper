#!/usr/bin/env ruby

require 'pry'
require 'nokogiri'
require 'rest-client'

class WormScraper
  def initialize
    starting_url = 'https://parahumans.wordpress.com/2011/06/11/1-1/'
    worm_scraper_looper(starting_url)
  end

  def worm_scraper_looper(current_url)
    fileHtml = File.new("Worm - a web serial.html", "w+")
    while current_url
      chapter_title, chapter_text, current_url = worm_scraper_engine_per_url(current_url)
      fileHtml.puts "<h2>#{chapter_title}</h2>"
      fileHtml.puts chapter_text
      fileHtml.puts "<br>"
    end
    fileHtml.close
  end

  def worm_scraper_engine_per_url(url)
    html = RestClient.get url
    html_doc = Nokogiri::HTML html
    chapter_title = html_doc.css('h1.entry-title').text
    chapter_text = html_doc.css('div.entry-content')[0].children[2..-5].to_html
    next_chapter = html_doc.css("a[title='Next Chapter']")[0].attributes['href'].value
    [chapter_title, chapter_text, next_chapter]
  end
end

WormScraper.new
