get '/teapot' do
  status 418
  "I'm a teapot"
end

get '/ping' do
  "Pong!"
end

get '/ip' do
  client_ip = request.env['HTTP_X_FORWARDED_FOR'] || 
              request.env['HTTP_X_REAL_IP'] || 
              request.ip
  
  # X-Forwarded-For can contain multiple IPs, take the first one
  client_ip = client_ip.split(',').first.strip if client_ip.include?(',')
  
  "Your IP address is: #{client_ip}"
end

get '/api' do
  content_type :json
  routes = settings.routes
    .reject { |verb, _| verb.upcase == 'HEAD' }
    .flat_map { |verb, routes_array|
      routes_array.map { |route|
        { method: verb.upcase, path: route[0].to_s }
      }
    }
    .select { |r| r[:path].start_with?('/api/') }.to_json
end

get '/api/fizzbuzz.json' do
  n = params[:n].to_i
  if n
    result = ''
    result += 'FIZZ' if n % 3 == 0
    result += 'BUZZ' if n % 5 == 0
    status 200
    content_type :json
    { result: result == '' ? n : result }.to_json
  else
    status 400
    content_type :json
    { error: 'Must provide valid ?n= query argument.' }.to_json
  end
end

get '/api/backup.tar.gz' do
  protected!
  require 'tempfile'
  content_type 'application/gzip'
  attachment 'backup.tar.gz'
  temp_tar = Tempfile.new(['backup', '.tar.gz'])
  tar_command = "tar -czf #{temp_tar.path} -C #{settings.root} data environment.yml"
  system(tar_command)
  send_file temp_tar.path, type: 'application/gzip'
end

ALLOWED_EXTENSIONS = ['jpg']

get '/data/:file_name.:ext' do
  file_name = params[:file_name]
  ext = params[:ext]
  if ALLOWED_EXTENSIONS.include?(ext)
    file_path = "data/#{file_name}.#{ext}"
    if File.file?(file_path)
      send_file file_path
    else
      status 404
    end
  else
    status 401
  end
end

not_found do
  status 404
  @copy = { title: "Louis Machin – 404" }
  erb :not_found, locals: { copy: @copy }
end

get '/robots.txt' do
  content_type 'text/plain'
  <<~ROBOTS
    User-agent: *
    Allow: /
    Disallow: /
    Disallow: /api/
    Disallow: /other-path/
  ROBOTS
end
