namespace :examples do
  task :reload => :environment do
    Haml::Template.options[:ugly] = false
    
    (Rails.root + "examples").entries.each do |file| 
      next if file.to_s[0, 1] == '.'
      Example.load_from_fs(Rails.root + "examples" + file)
    end
  end
end