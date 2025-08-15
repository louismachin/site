task :run do
  require_relative './app.rb'
  Sinatra::Application.run!
end

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
    
    puts "Altering environment..."
    require 'yaml'
    
    env_file = 'environment.yml'
    if File.exist?(env_file)
      config = YAML.load_file(env_file)
      config['base_url'] = "http://localhost:#{config['port']}"
      config['production'] = false

      yaml_output = YAML.dump(config, {
        line_width: -1,
        indentation: 2,
        canonical: false,
      })

      File.write(env_file, yaml_output)
    else
      puts "Warning: environment.yml not found"
    end

    puts "Done!"
  end
end
