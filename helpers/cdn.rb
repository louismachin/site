def cdn_download(cdn_path, local_path)
    uri = 'https://cdn.louismachin.com/download' + cdn_path
    api_key = $env.data.dig('cdn', 'api_key')
    res = simple_get(uri, { :api_key => api_key })
    return false unless res.is_a?(Net::HTTPSuccess)
    FileUtils.mkdir_p(File.dirname(local_path))
    File.binwrite(local_path, res.body)
    true
end

def cdn_sha256(cdn_path)
    uri = 'https://cdn.louismachin.com/hash' + cdn_path
    api_key = $env.data.dig('cdn', 'api_key')
    body = simple_get_body(uri, { :api_key => api_key })
    body ? body['sha256'] : nil
end

$ark_cache == nil

def get_ark_content
    return $ark_cache unless $ark_cache.nil?
    uri, iotas = 'https://ark.louismachin.com/api/tags/blog.json', []
    (simple_get_body(uri) || []).each { |payload| iotas << ArkIota.new(payload) }
    $ark_cache = iotas
    return iotas
end