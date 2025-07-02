def get_home_content
  result = { writings: [], fragments: [], pictures: [] }
  for file_path in Dir['./data/*.yml'] do
    document = Document.new(file_path)
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

def get_documents(type = nil)
  result = []
  for file_path in Dir['./data/*.yml'] do
    document = Document.new(file_path)
    next unless is_logged_in? || document.is_public?
    result << document if document.is?(type) || (type == nil)
  end
  return result.sort { |a, b| b.date <=> a.date }
end

def find_document(id)
  file_path = "./data/#{id}.yml"
  puts "find_document(id)\tid=#{id}"
  return nil unless File.file?(file_path)
  return Document.new(file_path)
end