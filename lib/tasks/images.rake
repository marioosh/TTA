namespace :images do

    desc "Reload card images."
    task :cards => :environment do
      CardImage.all.each do |ci|
        if ci.file
          filename = File.basename(ci.file.url)
          ci.file = File.new "public/files/source/#{filename}"
          ci.save
        end
      end

      puts "DONE."
    end
end