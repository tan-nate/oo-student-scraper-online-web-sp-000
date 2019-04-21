require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    flatiron_profiles = Nokogiri::HTML(html)
    
    profiles = []
   
    flatiron_profiles.css("div.student-card").each do |profile|
      profile_hash = {:name => nil, :location => nil, :profile_url => nil}
      profile_hash[:name] = profile.css("h4.student-name").text
      profile_hash[:location] = profile.css("p.student-location").text
      profile_hash[:profile_url] = profile.css("a").attribute("href").value
      profiles << profile_hash
    end
    
    profiles
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    profile_page = Nokogiri::HTML(html)
    
    user_profile = {}
   
    profile_page.css("div.social-icon-container").each do |social_heading|
      social_heading.css("a").each do |social_link|
        binding.pry

        site = social_link.value.scan(/\w+/)[1].to_sym
        
        user_profile[site] = social_link.css("a").attribute("href").value
      end
    end
    
    user_profile
  end
end
