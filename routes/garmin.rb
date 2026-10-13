$garmin_data = {}

helpers do
    def step_count
       return $garmin_data.dig('steps') || 0
    end
end

post '/api/garmin' do
    data = JSON.parse(request.body.read)
    $garmin_data = data
    { success: true }.to_json
end