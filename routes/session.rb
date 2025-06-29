COOKIE_NAME = '_louismachin'

helpers do
  def is_valid_key?(attempt)
    return $env.auth_key == attempt
  end

  def is_logged_in?
    cookie = request.cookies[COOKIE_NAME]
    cookie && $env.given_tokens.include?(cookie)
  end

  def protected!
    redirect '/login' unless is_logged_in?
  end
end

get '/login' do
  erb :login
end

post '/login' do
  data = JSON.parse(request.body.read)
  attempt = data["sequence"].join('-')
  if is_valid_key?(attempt)
    token = $env.new_token
    response.set_cookie(COOKIE_NAME, value: token, path: '/', max_age: '3600')
    content_type :json
    status 200
    { success: true, token: token }.to_json
  else
    content_type :json
    status 401
    { success: false, error: "Invalid password" }.to_json
  end
end

get '/logout' do
  token = request.cookies[COOKIE_NAME]
  GIVEN_TOKENS.delete(token) if token
  response.delete_cookie(COOKIE_NAME, path: '/')
  redirect '/'
end