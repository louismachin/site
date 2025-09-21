get '/writings' do
  @copy = $default_copy.but(title: "Louis Machin — Writings")
  @content = get_documents(DocumentType::Writing)
  erb :writings, locals: { copy: @copy, content: @content }
end

get '/fragments' do
  @copy = $default_copy.but(title: "Louis Machin — Fragments")
  @content = get_documents(DocumentType::Fragment)
  erb :fragments, locals: { copy: @copy, content: @content }
end

get '/pictures' do
  @copy = $default_copy.but(title: "Louis Machin — Pictures")
  @content = get_documents(DocumentType::Picture)
  erb :pictures, locals: { copy: @copy, content: @content }
end

get '/archive' do
  protected!
  @copy = $default_copy.but(title: "Louis Machin — Archive")
  @content = get_documents
  erb :archive, locals: { copy: @copy, content: @content }
end

get '/about' do
  @copy = $default_copy.but(title: "Louis Machin — About")
  @document = find_document('about')
  redirect '/' unless @document
  erb :writing, locals: { copy: @copy, document: @document }
end

get '/read/:id' do
  @document = find_document(params[:id])
  redirect '/' unless @document
  redirect '/' unless is_logged_in? || @document.is_public?
  @copy = $default_copy.but(title: @document.title)
  if @document.is_picture?
    erb :picture, locals: { copy: @copy, document: @document }
  elsif @document.is_fragment?
    erb :fragment, locals: { copy: @copy, document: @document }
  elsif @document.is_writing?
    erb :writing, locals: { copy: @copy, document: @document }
  end
end