get '/write' do
  protected!
  @copy = $default_copy.but(title: "Louis Machin — Write")
  erb :write, locals: { copy: @copy }
end

get '/write/:id' do
  protected!
  @document = find_document(params[:id])
  if @document
    @copy = $default_copy.but(title: "Louis Machin — Write")
    erb :write, locals: { copy: @copy, document: @document }
  else
    redirect '/'
  end
end

post '/write' do
  protected!
  data = JSON.parse(request.body.read)
  document = Document.new
  document.set_metadata({
    'id' => data['id'],
    'title' => data['title'],
    'date' => Date.today.to_s,
    'fragment' => data['fragment'],
    'public' => data['public'],
  })
  document.save(data['body'])
  { success: true }.to_json
end

get '/api/toggle_privacy' do
  protected!
  document = find_document(params[:id])
  if document
    document.toggle_privacy
    document.save
    { success: true }.to_json
  else
    status 400
    { success: false, error: 'Could not find document' }.to_json
  end
end