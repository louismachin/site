require_relative './simple_web'

def ingest_fragments_from_cdn
    base_uri = 'https://cdn.louismachin.com'
    params = { api_key: 'eVQWcT28VshwwQ' }
#   params = { api_key: $env.cdn_api_key }
    response = simple_get_body(base_uri + '/list/notes', params)
    for file in response['files']
        uri = base_uri + '/download/notes/' + CGI.escape(file)
        download = simple_get(uri, params)
        puts download.body
    end
end

ingest_fragments_from_cdn