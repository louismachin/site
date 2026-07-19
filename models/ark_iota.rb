class ArkIota
    # https://github.com/louismachin/ark
    # https://ark.louismachin.com

    def initialize(hash)
        @hash = hash
    end

    def to_json
        @hash.to_json
    end

    def tags
        @hash.dig('tags') || []
    end

    def writing?
        @hash.dig('type') == 'writing'
    end

    def picture?
        @hash.dig('type') == 'picture'
    end

    def fragment?
        tags.include?('fragment')
    end
    
    def public?
        (!['blog_about'].include?(key))
    end

    def encoded?
        return tags.include?('encoded')
    end

    def date
        @hash.dig('created_at') || Date.today.to_s
    end

    def time
        Time.parse(self.date)
    end

    def pub_date
        # RSS format
        self.time.strftime('%a, %d %b %Y %H:%M:%S %z')
    end

    def metadata
        @hash.dig('metadata') || {}
    end

    def key
        self.metadata.dig('key')
    end

    def id
        self.key || @hash.dig('id')
    end

    def title
        @hash.dig('title') || 'Untitled'
    end

    def description
        @hash.dig('description') || 'N/A'
    end

    def links
        @hash.dig('links') || []
    end

    def uri
        self.links.first
    end

    def thumbnail_uri
        self.links.size > 1 ? self.links[1] : self.uri
    end

    def raw_content
        self.description.force_encoding('UTF-8')
    end

    def content
        data = raw_content
        data ? parse_markdown(data) : ''
    end

    def cipher_text
        return '' unless self.writing?
        encode_from_raw_content(self.raw_content)
    end

    def link
        "#{$env.base_url}/read/#{self.id}"
    end
end