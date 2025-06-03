namespace :articles do
desc "remove article which report more than 6 times"
  task remove_highly_reported: :environment do
    Article.where("report_count >= ?", 6).destroy_all
    puts "Deleted articles reported more than 6 times"
  end
end
