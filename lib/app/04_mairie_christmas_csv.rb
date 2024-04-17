require 'csv'
require 'nokogiri'
require 'open-uri'

class TownhallEmailScraper
  def initialize(url)
    @url = url
  end

  def fetch_data
    doc = Nokogiri::HTML5(URI.open(@url))
    townhall_page = doc.xpath('//article[contains(@class, "directory-block__item")]')
    townhall_list = {}

    townhall_page.each do |block|
      city = block.xpath('.//h2').text
      email = block.xpath('.//p[3]/a').text
      townhall_list[city] = email unless email.empty?
    end

    townhall_list
  end

  def save_as_csv(file_name)
    data = fetch_data

    CSV.open(file_name, 'wb') do |csv|
      csv << ['City', 'Email'] # Headers
      data.each do |city, email|
        csv << [city, email]
      end
    end
  end
end

# Utilisation de la classe
scraper = TownhallEmailScraper.new("https://www.aude.fr/annuaire-mairies-du-departement")
scraper.save_as_csv('townhall_emails.csv')
