$ark_cache == nil

def get_ark_content
    if $ark_cache == nil
        uri = 'https://ark.louismachin.com/api/tags/blog.json'
        iotas = []
        for payload in (simple_get_body(uri) || []) do
            iotas << ArkIota.new(payload)
        end
        $doc_cache = iotas
        return iotas
    else
        return $ark_cache
    end
end