require 'yaml'
require 'fileutils'

module DocumentType
    None = 'None',
    Writing = 'Writing',
    Fragment = 'Fragment',
    Picture = 'Picture'
end

class Document
    attr_accessor :metadata

    def initialize(file_name = nil, metadata = {})
        @file_name = file_name
        @metadata = metadata
    end

    def to_json
        data = {
            id: self.id,
            title: self.title,
            date: self.date,
            uri: self.uri,
        }
        if is_picture?
            data[:thumbnail_uri] = self.thumbnail_uri
        end
        if is_fragment?
            data[:content] = self.content
        end
        return data
    end

    def id
        @file_name.split('.')[0]
    end

    def is_public?
        @metadata.dig('public') == 'true'
    end

    def is_private?
        !self.is_private?
    end

    def is_writing?
        !(self.is_fragment? || self.is_picture?)
    end

    def is_fragment?
        val = (@metadata.dig('fragment') == 'true')
        val == nil ? false : val
    end

    def is_picture?
        ['png', 'jpg', 'jpeg'].include?(@file_name.split('.')[1])
    end

    def is?(document_type)
        return self.document_type == document_type
    end

    def document_type
        return DocumentType::Writing if is_writing?
        return DocumentType::Fragment if is_fragment?
        return DocumentType::Picture if is_picture?
        return DocumentType::Writing # default
    end

    def raw_content
        data = simple_get(self.uri).body
        data = data.force_encoding('UTF-8')
        return data
    end

    def content
        data = raw_content
        data ? parse_markdown(data) : ''
    end

    def is_encoded?
        @metadata.dig('encode') == 'true'
    end

    def cipher_text
        if (is_writing? || is_fragment?)
            encode_from_raw_content(self.raw_content)
        else
            ''
        end
    end

    def title
        @metadata.dig('title') || self.id
    end

    def description
        return 'TODO: Add description'
    end

    def date
        @metadata.dig('date') || '2020-01-01'
    end

    def time
        Time.parse(self.date)
    end

    def pub_date
        # RSS format
        self.time.strftime('%a, %d %b %Y %H:%M:%S %z')
    end

    def link
        "https://cdn.louismachin.com/dl/public/blog_content/#{@file_name}"
    end

    def uri
        "https://cdn.louismachin.com/dl/public/blog_content/#{@file_name}"
    end

    def thumbnail_uri
        # TODO: check if .thumb exists
        "https://cdn.louismachin.com/dl/public/blog_content/#{@file_name}"
    end
end