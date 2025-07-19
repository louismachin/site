get '/rss.xml' do
  content_type 'text/xml'
  @content = get_documents(DocumentType::Writing)
  @last_build_date = Time.now.strftime('%a, %d %b %Y %H:%M:%S %z')
  @pub_date = @content.map(&:pub_date).max
  erb :rss, locals: {
    content: @content,
    last_build_date: @last_build_date,
    pub_date: @pub_date,
  }
end