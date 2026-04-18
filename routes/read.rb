get '/writings' do
    @copy = $default_copy.but(title: "Louis Machin — Writings")
    @content = get_documents.select { |doc| doc.is_writing? && doc.public? }
    erb :writings, locals: { copy: @copy, content: @content }
end

get '/fragments' do
    @copy = $default_copy.but(title: "Louis Machin — Fragments")
    @content = get_documents.select { |doc| doc.fragment? && doc.public? }
    erb :fragments, locals: { copy: @copy, content: @content }
end

get '/pictures' do
    @copy = $default_copy.but(title: "Louis Machin — Pictures")
    @content = get_documents.select { |doc| doc.picture? && doc.public? }
    @bad_photos = get_bad_photos
    erb :pictures, locals: { copy: @copy, content: @content, bad_photos: @bad_photos }
end

get '/about' do
    @copy = $default_copy.but(title: "Louis Machin — About")
    @document = find_document('blog_about')
    redirect '/' unless @document
    erb :writing, locals: { copy: @copy, document: @document }
end

get '/read/:id' do
    id = params[:id]
    @document = params[:bad_photo] ? find_bad_photo(id) : find_document(id)
    redirect '/' unless @document
    redirect '/' unless is_logged_in? || @document.public?
    @copy = $default_copy.but(title: @document.title)
    if @document.picture?
        erb :picture, locals: { copy: @copy, document: @document }
    elsif @document.fragment?
        erb :fragment, locals: { copy: @copy, document: @document }
    elsif @document.is_writing?
        erb :writing, locals: { copy: @copy, document: @document }
    end
end