get '/guestbook' do
    @entries = $guestbook.public_entries
    @hide_form = params['form'] == '0'
    render_page(title: 'Louis Machin — Guestbook', key: 'guestbook')
end

post '/guestbook' do
    data = JSON.parse(request.body.read)
    $guestbook.add(data['name'], data['message'])
    { success: true }.to_json
end