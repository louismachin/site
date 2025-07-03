get '/upload' do
  protected!
  @copy = { title: 'Louis Machin' }
  erb :upload, locals: { copy: @copy }
end

post '/api/upload' do
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