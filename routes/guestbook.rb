get '/guestbook' do
  @copy = { title: "Guestbook" }
  @entries = $guestbook.public_entries
  @hide_form = params['form'] == '0'
  erb :guestbook, locals: {
    copy: @copy, entries: @entries, hide_form: @hide_form
  }
end

post '/guestbook' do
  data = JSON.parse(request.body.read)
  $guestbook.add(data['name'], data['message'])
  { success: true }.to_json
end