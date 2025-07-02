get '/' do
  @copy = { title: "Louis Machin" }
  @content = get_home_content
  erb :home, locals: { copy: @copy, content: @content }
end

get '/writings' do
  @copy = { title: "Writings" }
  @content = get_documents(DocumentType::Writing)
  erb :writings, locals: { copy: @copy, content: @content }
end

get '/fragments' do
  @copy = { title: "Fragments" }
  @content = get_documents(DocumentType::Fragment)
  erb :fragments, locals: { copy: @copy, content: @content }
end

get '/pictures' do
  @copy = { title: "Pictures" }
  @content = get_documents(DocumentType::Picture)
  erb :pictures, locals: { copy: @copy, content: @content }
end

get '/archive' do
  protected!
  @copy = { title: "Archive" }
  @content = get_documents
  erb :archive, locals: { copy: @copy, content: @content }
end

get '/about' do
  @copy = { title: "Louis Machin" }
  @file_path = "./data/about.md"
  erb :writing, locals: { copy: @copy, file_path: @file_path }
end

get '/archive' do
  protected!
  @copy = { title: "Archive" }
  @file_path = "./data/about.md"
  erb :writing, locals: { copy: @copy, file_path: @file_path }
end

get '/read/:id' do
  file_path = "./data/#{params[:id]}.yml"
  document = Document.new(file_path)
  redirect '/' unless document 
  redirect '/' unless is_logged_in? || document.is_public?
  @copy = { title: document.title }
  @file_path = document.file_path
  if document.is_picture?
    erb :picture, locals: { copy: @copy, file_path: @file_path }
  elsif document.is_writing?
    erb :writing, locals: { copy: @copy, file_path: @file_path }
  elsif document.is_fragment?
    @entry = document.to_json
    erb :fragment, locals: { copy: @copy, entry: @entry }
  end
end