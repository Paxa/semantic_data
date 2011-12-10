namespace :posts do
  task :reload => :environment do
    (Rails.root + "posts").entries.each do |file| 
      next if file.to_s[0, 1] == '.'
      Post.from_file(Rails.root + "posts" + file)
    end
  end
end