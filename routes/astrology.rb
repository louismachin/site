get '/api/horoscope.json' do
    bearer_token = $env.data.dig('costar', 'bearer_token')
    date = Time.now.utc.iso8601
    uri = "https://api.costarastrology.com/user/current/timeline/v1/daily/#{date}"
    params = {}
    headers = {
        'Accept': 'application/json',
        'Authorization': bearer_token,
        'Content-Type': 'application/json',
    }
    response_body = get_body(uri, params, headers)
    horoscope = response_body.dig('today', 'pushNotificationText')
    if horoscope
        status 200
        content_type :json
        { horoscope: horoscope }.to_json
    else
        status 400
        content_type :json
        { error: 'Could not get horoscope' }.to_json
    end
end

get '/api/astro_analysis.json' do
    protected!
    entity = $env.data.dig('costar', 'birthed_entity')
    bearer_token = $env.data.dig('costar', 'bearer_token')
    uri = "https://api.costarastrology.com/birthed_entity/#{entity}/astro_analysis"
    params = {}
    headers = {
        'Accept': 'application/json',
        'Authorization': bearer_token,
        'Content-Type': 'application/json',
    }
    response_body = simple_get_body(uri, params, headers)
    content_type :json
    response_body.to_json
end

get '/api/costar.json' do
    protected!
    bearer_token = $env.data.dig('costar', 'bearer_token')
    uri = "https://api.costarastrology.com/user/current"
    params = {}
    headers = {
        'Accept': 'application/json',
        'Authorization': bearer_token,
        'Content-Type': 'application/json',
    }
    response_body = simple_get_body(uri, params, headers)
    content_type :json
    response_body.to_json
end