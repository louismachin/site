get '/write' do
  protected!
  @copy = { title: 'Louis Machin' }
  erb :write, locals: { copy: @copy }
end

get '/write/:id' do
  protected!
  @document = find_document(params[:id])
  if @document
    @copy = { title: 'Louis Machin' }
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

get '/upload_picture' do
  protected!
  @copy = { title: 'Louis Machin' }
  erb :upload_picture, locals: { copy: @copy }
end

post '/api/upload_picture' do
  protected!
  unless params[:file] && params[:id]
    halt 400, { 'success' => false, 'error' => 'Missing required fields' }.to_json
  end
  # Get values
  file = params[:file][:tempfile]
  filename = params[:file][:filename]
  id = params[:id].strip
  title = params[:title] || params[:id]
  extension = File.extname(filename)
  save_path = File.expand_path("data/#{id}#{extension}", APP_ROOT)
  # Create file
  FileUtils.mkdir_p(File.dirname(save_path))
  File.open(save_path, 'wb') { |f| f.write(file.read) }
  # Create metadata
  document = Document.new
  document.set_metadata({
    'id' => id,
    'title' => title,
    'format' => extension.gsub('.', ''),
    'public' => params.key?('public'),
    'date' => Date.today.to_s,
  })
  document.save
  # Return result
  content_type :json
  { 'success' => true, }.to_json
end