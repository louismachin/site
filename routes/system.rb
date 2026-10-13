get '/teapot' do
    halt 418, "I'm a teapot"
end

get '/ping' do
    "Pong!"
end

get '/ip' do
    return "Your IP address is: #{get_single_ip}"
end

get '/ip.json' do
    { ip: get_single_ip }.to_json
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
        { result: result == '' ? n : result }.to_json
    else
        halt 400, { error: 'Must provide valid ?n= query argument.' }.to_json
    end
end

get '/api/reload.json' do
    $reloaders.each { |reloader| reloader.call }
    { success: true }.to_json
end

ALLOWED_EXTENSIONS = ['jpg']

get '/data/:file_name.:ext' do
    file_name, ext = params[:file_name], params[:ext]
    file_path = "data/#{file_name}.#{ext}"
    halt 401 unless ALLOWED_EXTENSIONS.include?(ext)
    halt 404 unless File.file?(file_path)
    send_file file_path
end

not_found do
    status 404
    render_page(title: 'Louis Machin — 404')
end