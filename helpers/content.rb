def get_documents
    get_ark_content
end

def find_document(id)
    get_documents.each { |doc| return doc if id == doc.id }
    return nil
end

$bad_photos_cache = nil

def get_bad_photos
    uri = 'https://cdn.louismachin.com/list/public/bad_photos'
    body = simple_get_body(uri)
    bad_photos = body["files"].map { |filename| BadPhoto.new(filename) }
    $bad_photos_cache = [
        bad_photos.select(&:kodak?).reverse,
        bad_photos.select(&:nokia?).reverse,
    ].flatten
    return $bad_photos_cache
rescue => e
    puts e.message
    return []
end

def find_bad_photo(id)
    get_bad_photos.each { |bad_photo| return bad_photo if id == bad_photo.id }
    return nil
end

def get_home_content
    result = { writings: [], fragments: [], pictures: [] }
    for document in get_documents do
        next unless is_logged_in? || document.public?
        result[:writings] << document if document.writing?
        result[:fragments] << document if document.fragment?
        result[:pictures] << document if document.picture?
    end
    for key in result.keys do
        result[key] = result[key].sort { |a, b| b.date <=> a.date }.first(5)
    end
    return result
end