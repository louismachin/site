get '/upload' do
  protected!
  <<~HTML
    <!DOCTYPE html>
    <html>
      <head>
        <title>Upload a File</title>
      </head>
      <body>
        <form action="/upload" method="POST" enctype="multipart/form-data">
          <input type="file" name="file">
          <button type="submit">Upload</button>
        </form>
      </body>
    </html>
  HTML
end


post '/upload' do
  protected!
  if params[:file] &&
    (tempfile = params[:file][:tempfile]) &&
    (filename = params[:file][:filename])
    save_path = File.join(APP_ROOT, 'uploads', filename)
    FileUtils.mkdir_p(File.dirname(save_path)) # ensure dir exists
    File.open(save_path, 'wb') do |f|
      f.write(tempfile.read)
    end
    "File uploaded successfully to #{save_path}"
  else
    status 400
    "No file uploaded"
  end
end