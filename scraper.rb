require 'uk_planning_scraper'
require 'scraperwiki'

auths = UKPlanningScraper::Authority.tagged('london')

auths.each_with_index do |auth, i|
  begin
    puts "#{i + 1} of #{auths.size}: Scraping #{auth.name}"
    apps = auth.scrape({ decided_days: ENV['MORPH_DAYS'].to_i })
    ScraperWiki.save_sqlite([:authority_name, :council_reference], apps)
    puts "#{auth.name}: #{apps.size} application(s) saved."
  rescue UKPlanningScraper::SystemNotSupportedError => e
    puts e
  end
end
