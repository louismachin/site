$doc_cache = nil

def get_uri_list
  uri = 'https://text.louismachin.com/api/list'
  body = simple_get_body(uri, { api_key: $env.leaf_api_key, tags: 'blog' })
  return body['uris']
end

def get_documents
  if $doc_cache == nil
    base_uri = 'https://text.louismachin.com'
    documents = []
    get_uri_list.each do |path|
      uri = base_uri + path
      leaf_json = simple_get_body(uri, { api_key: $env.leaf_api_key })
      leaf = Leaf.new(uri, leaf_json['attributes'], leaf_json['body'])
      documents << leaf
    end
    $doc_cache = documents
    return documents
  else
    return $doc_cache
  end
end

def find_document(id)
  get_documents.each { |doc| return doc if id == doc.id }
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