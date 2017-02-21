require 'highline/import'

namespace :db do

  desc 'loads sample data'
  task sample: :environment do
    say "Reseting DB ..."
    Rake::Task["db:reset"].invoke

    say "Seeding DB ..."
    Rake::Task["db:seed"].invoke

    dir = File.join(Rails.root, "db/sample")
    say "Loading files from: #{dir}"

    files = Dir["#{dir}/*.rb"]
    files.sort.each do |file|
      say "Loading: #{File.basename(file)}"
      load file
    end
  end

end
