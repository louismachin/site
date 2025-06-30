get '/teapot' do
  status 418
  "I'm a teapot"
end

get '/ping' do
  "Pong!"
end

get '/ip' do
  "Your IP address is: #{request.ip}"
end

get '/api/fizzbuzz' do
  n = params[:n]
  if n
    result = ''
    result += 'FIZZ' if n % 3 == 0
    result += 'BUZZ' if n % 5 == 0
    status 200
    result == '' ? n : result
  else
    status 400
    { error: 'Must provide valid ?n= query argument.' }.to_json
  end
end

get '/api/backup.tar.gz' do
  protected!
  require 'tempfile'
  content_type 'application/gzip'
  attachment 'backup.tar.gz'
  temp_tar = Tempfile.new(['backup', '.tar.gz'])
  tar_command = "tar -czf #{temp_tar.path} -C #{settings.root} data"
  system(tar_command)
  send_file temp_tar.path, type: 'application/gzip'
end

ALLOWED_EXTENSIONS = ['jpg']

get '/data/:file_name.:ext' do
  file_name = params[:file_name]
  ext = params[:ext]
  if ALLOWED_EXTENSIONS.include?(ext)
    file_path = "data/#{file_name}.#{ext}"
    if File.file?(file_path)
      send_file file_path
    else
      status 404
    end
  else
    status 401
  end
end

not_found do
  status 404
  @copy = { title: "Louis Machin – 404" }
  erb :not_found, locals: { copy: @copy }
end