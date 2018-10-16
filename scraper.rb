require 'uk_planning_scraper'
require 'scraperwiki'

auths = UKPlanningScraper::Authority.tagged('london')

params = %w(validated_days decided_days)

auths.each_with_index do |auth, i|
  params.each_with_index do |param, j|
    puts "Authority #{i + 1} of #{auths.size}: Scrape #{j + 1} of #{params.size} for #{auth.name}."
    begin
      apps = auth.send(param, ENV['MORPH_DAYS'].to_i).scrape
      ScraperWiki.save_sqlite([:authority_name, :council_reference], apps)
      puts "#{auth.name}: #{apps.size} application(s) saved."
    rescue StandardError => e
      puts e
    end
  end
end
