get '/teapot' do
    halt 418, "I'm a teapot"
end

get '/ping' do
    "Pong!"
end

get '/ip' do
    client_ip = request.env['HTTP_X_FORWARDED_FOR'] || request.env['HTTP_X_REAL_IP'] || request.ip
    # X-Forwarded-For can contain multiple IPs, take the first one
    client_ip = client_ip.split(',').first.strip if client_ip.include?(',')
    return "Your IP address is: #{client_ip}"
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

get '/reload' do
    $reloaders.each { |reloader|
        puts "Calling #{reloader.inspect}..."
        reloader.call
    }
	redirect '/'
end

ALLOWED_EXTENSIONS = ['jpg']

get '/data/:file_name.:ext' do
    file_name = params[:file_name]
    ext = params[:ext]
    file_path = "data/#{file_name}.#{ext}"
    halt 401 unless ALLOWED_EXTENSIONS.include?(ext)
    halt 404 unless File.file?(file_path)
    send_file file_path
end

not_found do
    status 404
    @copy = $default_copy.but(title: "Louis Machin — 404")
    erb :not_found, locals: { copy: @copy }
end
