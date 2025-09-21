$doc_cache = nil

def get_documents(filter_type = nil, ignore_privacy = false)
  if $doc_cache == nil
    base_uri = "https://cdn.louismachin.com"
    uri = "#{base_uri}/list/public/blog_content"
    files = simple_get_body(uri).dig('files')
    documents = []
    files.each do |file|
      uri = "#{base_uri}/info/public/blog_content/#{file}"
      metadata = simple_get_body(uri)
      documents << Document.new(file, metadata)
    end
    # Sort by date
    documents = documents.sort { |a, b| b.date <=> a.date }
    # Cache full list of documents
    $doc_cache = documents.map(&:clone)
  else
    documents = $doc_cache.map(&:clone)
  end
  # Filter if filter type selected
  documents.select! { |doc| doc.is?(filter_type) } unless filter_type == nil
  # Filter private unless logged in or privacy ignored
  documents.select! { |doc| doc.is_public? } unless ignore_privacy || is_logged_in? 
  return documents
end

def find_document(id)
  filter_type, ignore_privacy = nil, true
  get_documents(filter_type, ignore_privacy)
    .each { |doc| return doc if id == doc.id }
  return nil
end

def get_home_content
  result = { writings: [], fragments: [], pictures: [] }
  for document in get_documents do
    next unless is_logged_in? || document.is_public?
    result[:writings] << document if document.is_writing?
    result[:fragments] << document if document.is_fragment?
    result[:pictures] << document if document.is_picture?
  end
  for key in result.keys do
    result[key] = result[key]
      .sort { |a, b| b.date <=> a.date }.first(5).map(&:to_json)
  end
  return result
end