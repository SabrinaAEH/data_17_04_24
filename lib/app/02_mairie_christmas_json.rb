require 'json'
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

  def save_as_JSON(file_name)
    data = fetch_data
    File.open(file_name, 'w') do |file|
      file.write(JSON.pretty_generate(data))
    end
  end
end

# Utilisation de la classe
scraper = TownhallEmailScraper.new("https://www.aude.fr/annuaire-mairies-du-departement")
scraper.save_as_JSON('emails.json')
