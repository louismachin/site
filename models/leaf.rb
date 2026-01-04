class Leaf
    # https://github.com/louismachin/leaf

    def initialize(api_uri, attributes, body)
        @api_uri = api_uri
        @attributes = attributes
        @body = body
    end

    def to_json
        data = {
            id: self.key,
            title: self.title,
            date: self.date,
        }
        if is_picture?
            data[:uri] = self.uri
            data[:thumbnail_uri] = self.thumbnail_uri
        end
        if is_fragment?
            data[:content] = self.content
        end
        return data
    end

    def tags
        @attributes.key?('tags') ? @attributes['tags'] : []
    end

    def is_picture?
        @attributes.key?('media')
    end

    def is_fragment?
        return tags.include?('fragment')
    end
    
    def is_writing?
        return false if is_picture?
        return false if is_fragment?
        return true
    end
    
    def is_public?
        return (!['blog_about'].include?(key))
    end

    def is_encoded?
        return tags.include?('encoded')
    end

    def date
        @attributes.key?('created_at') ? @attributes['created_at'] : Date.today.to_s
    end

    def time
        Time.parse(self.date)
    end

    def pub_date
        # RSS format
        self.time.strftime('%a, %d %b %Y %H:%M:%S %z')
    end

    def key
        @attributes['key']
    end

    def id
        @attributes['key']
    end

    def title
        @attributes.key?('title') ? @attributes['title'] : 'Untitled'
    end

    def description
        @attributes.key?('description') ? @attributes['description'] : 'N/A'
    end

    def uri
        @attributes['media']
    end

    def thumbnail_uri
        @attributes.key?('thumbnail') ? @attributes['thumbnail'] : @attributes['media']
    end

    def edit_uri
        return @api_uri.sub('/api', '') + '/edit'
    end

    def raw_content
        data = @body.join("\n")
        data = data.force_encoding('UTF-8')
        return data
    end

    def content
        data = raw_content
        data ? parse_markdown(data) : ''
    end

    def cipher_text
        if (is_writing? || is_fragment?)
            encode_from_raw_content(self.raw_content)
        else
            ''
        end
    end

    def link
        return ''
    end
end