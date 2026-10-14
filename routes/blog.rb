get '/' do
    @content = get_home_content
    render_page(title: 'Louis Machin', key: 'home')
end

get '/writings' do
    @content = get_documents.select { |doc| doc.writing? && (!doc.fragment?) && doc.public? }.sort { |a, b| b.date <=> a.date }
    render_page(title: 'Louis Machin — Writings', key: 'writings')
end

get '/fragments' do
    @content = get_documents.select { |doc| doc.fragment? && doc.public? }.sort { |a, b| b.date <=> a.date }
    render_page(title: 'Louis Machin — Fragments', key: 'fragments')
end

get '/pictures' do
    @content = get_documents.select { |doc| doc.picture? && doc.public? }.sort { |a, b| b.date <=> a.date }
    @bad_photos = get_bad_photos
    render_page(title: 'Louis Machin — Pictures', key: 'pictures')
end

get '/about' do
    @document = find_document('blog_about')
    redirect '/' unless @document
    render_page(title: 'Louis Machin — About', key: 'writing')
end

get '/read/:id' do
    @document = params[:bad_photo] ? find_bad_photo(params[:id]) : find_document(params[:id])
    redirect '/' unless @document
    projected! unless @document.public?
    render_page(title: @document.title, key: 'picture') if @document.picture?
    render_page(title: @document.title, key: 'fragment') if @document.fragment?
    render_page(title: @document.title, key: 'writing') if @document.writing?
    not_found
end

get '/diary' do
    protected!
    @diary_entries = get_diary_entries
    render_page(title: 'Louis Machin — Diary', key: 'diary')
end