namespace :dev do
  desc "Download and unpack data from live instance"
  task :sync_from_live do
    puts "Authentication key:"
    auth_key = STDIN.gets.chomp
  
    puts "Downloading backup..."
    system("curl -o backup.tar.gz https://louismachin.com/api/backup.tar.gz?auth_key=#{auth_key}")
    
    puts "Extracting..."
    system("tar -xzf backup.tar.gz")
    
    puts "Cleaning up..."
    system("rm backup.tar.gz")
    
    puts "Done!"
  end
end
