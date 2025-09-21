get '/write' do
  protected!
  @copy = $default_copy.but(title: "Louis Machin — Write")
  erb :pomero, locals: { copy: @copy }
end

get '/write/:id' do
  protected!
  @document = find_document(params[:id])
  if @document
    @copy = $default_copy.but(title: "Louis Machin — Write")
    erb :pomero, locals: { copy: @copy, document: @document }
  else
    redirect '/'
  end
end

post '/write' do
  protected!
  data = JSON.parse(request.body.read)
  file_name = "#{data['id']}.md"
  document = Document.new(file_name)
  content = data['body']
  document.metadata = {
    'id' => data['id'],
    'title' => data['title'],
    'date' => Date.today.to_s,
    'fragment' => data['fragment'] ? 'true' : 'false',
    'public' => data['public'] ? 'true' : 'false',
  }
  document.save_content(content)
  document.save_metadata
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