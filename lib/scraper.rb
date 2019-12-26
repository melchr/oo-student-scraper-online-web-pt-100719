require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    html= open(index_url)
    student_scraper = Nokogiri::HTML(html)
    students = []

    student_scraper.css("div.student-card").each do |student|
     name = student.css(".student-name").text
     location = student.css(".student-location").text
     profile_url = student.css("a").attribute("href").value
     student_info = {:name => name, :location => location,
     :profile_url => profile_url}
     students << student_info
    end
    students
  end

  def self.scrape_profile_page(profile_url)

    html = open(profile_url)
    profile_scraper = Nokogiri::HTML(html)
    student_profile = {}

    links = profile_scraper.css("div.social-icon-container a").collect do |icon|
      icon.attribute("href").value
    end
    links.each do |link|
      if link.include?("twitter")
        student_profile[:twitter] = link
      elsif link.include?("linkedin")
        student_profile[:linkedin] = link
      elsif link.include?("github")
        student_profile[:github] = link
      elsif link.include?('.com')
        student_profile[:blog] = link
      end
        student_profile[:profile_quote] = profile_scraper.css(".profile-quote").text
        student_profile[:bio] = profile_scraper.css("div.description-holder p").text
    end
    student_profile
  end

end
