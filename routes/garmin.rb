$garmin_data = {}

post '/api/garmin' do
    data = JSON.parse(request.body.read)
    $garmin_data = data
    { success: true }.to_json
end

get '/project/garmin' do
    @data = $garmin_data
    erb :garmin
end