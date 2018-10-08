require 'uk_planning_scraper'
require 'scraperwiki'

auths = UKPlanningScraper::Authority.tagged('london')

scrapes = [
  { validated_days: ENV['MORPH_DAYS'].to_i },
  { decided_days: ENV['MORPH_DAYS'].to_i }
]

auths.each_with_index do |auth, i|
  scrapes.each_with_index do |scrape, j|
    puts "Authority #{i + 1} of #{auths.size}: Scrape #{j + 1} of #{scrapes.size} for #{auth.name}."
    begin
      apps = auth.scrape(scrape)
      ScraperWiki.save_sqlite([:authority_name, :council_reference], apps)
      puts "#{auth.name}: #{apps.size} application(s) saved."
    rescue StandardError => e
      puts e
    end
  end
end
