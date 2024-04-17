require 'nokogiri'
require 'open-uri'
require 'google_drive'

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

  def save_as_spreadsheet(spreadsheet_name)
    session = GoogleDrive::Session.from_config("config.json") # Remplacez "config.json" par le chemin de votre fichier de configuration
    ws = session.create_spreadsheet(spreadsheet_name).worksheets[0]
    
    data = fetch_data
    row_index = 1

    data.each do |city, email|
      ws[row_index, 1] = city
      ws[row_index, 2] = email
      row_index += 1
    end

    ws.save
  end
end

# Utilisation de la classe
scraper = TownhallEmailScraper.new("https://www.aude.fr/annuaire-mairies-du-departement")
scraper.save_as_spreadsheet('TownhallEmails')
