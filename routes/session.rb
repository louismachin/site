COOKIE_NAME = '_louismachin'

helpers do
    def is_valid_key?(attempt)
        return $env.auth_key == attempt
    end

    def is_logged_in?
        # Check if sent by param
        auth_key = request.params['auth_key']
        return true if auth_key && auth_key == $env.auth_key
        # Check if cookie is assigned
        cookie = request.cookies[COOKIE_NAME]
        cookie && $env.given_tokens.include?(cookie)
    end

    def is_not_logged_in?
        return !is_logged_in?
    end

    def protected!
        redirect '/login' unless is_logged_in?
    end

    def get_ip
        request.env['HTTP_X_FORWARDED_FOR'] || request.env['HTTP_X_REAL_IP'] || request.ip
    end

    def get_single_ip
        get_ip.as { |ip| ip.include?(',') ? ip.split(',').first.strip : ip }
    end
end

get '/login' do
    redirect '/' if is_logged_in?
    erb :login
end

post '/login' do
    data = JSON.parse(request.body.read)
    attempt = data["sequence"].join('-')
    halt 401, { success: false, error: "Invalid password" }.to_json unless is_valid_key?(attempt)
    token = $env.new_token
    response.set_cookie(COOKIE_NAME, value: token, path: '/', max_age: '3600')
    { success: true, token: token }.to_json
end

get '/logout' do
    token = request.cookies[COOKIE_NAME]
    $env.given_tokens.delete(token) if token
    response.delete_cookie(COOKIE_NAME, path: '/')
    redirect '/'
end
