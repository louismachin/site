require 'yaml'
require 'fileutils'

module DocumentType
    Writing = 0,
    Fragment = 1,
    Picture = 2
end

class Document
    attr_accessor :metadata
    def initialize(file_path = nil)
        @metadata = {}
        load_file(file_path) unless file_path == nil
    end

    def save(body = nil)
        puts "Saving #{self.id}..."
        puts @metadata.inspect
        dir = File.join(APP_ROOT, 'data')
        yaml_path = File.join(dir, "#{self.id}.yml")
        File.write(yaml_path, @metadata.to_yaml)
        if body
            md_path = File.join(dir, "#{self.id}.md")
            File.write(md_path, body)
        end
    end

    def load_file(file_path)
        if File.file?(file_path)
            @metadata = YAML.load_file(file_path)
        else
            return nil
        end
    end

    def set_metadata(metadata)
        @metadata = metadata
    end

    def to_json
        data = {
            id: self.id,
            title: self.title,
            date: self.date,
            file_path: self.file_path,
        }
        if is_picture?
            data[:thumbnail_file_path] = self.thumbnail_file_path
        end
        if is_fragment?
            data[:content] = self.content
        end
        return data
    end

    def is_public?
        @metadata.dig('public')
    end

    def is_writing?
        !(self.is_fragment? || self.is_picture?)
    end

    def is_fragment?
        val = @metadata.dig('fragment')
        val == nil ? false : val
    end

    def is_picture?
        ['png', 'jpg', 'jpeg'].include?(self.format)
    end

    def is?(document_type)
        return self.document_type == document_type
    end

    def document_type
        return DocumentType::Writing if is_writing?
        return DocumentType::Fragment if is_fragment?
        return DocumentType::Picture if is_picture?
    end

    def id
        @metadata.dig('id')
    end

    def file_path
        if self.is_picture?
            "/data/#{self.id}.#{self.format}"
        else
            "./data/#{self.id}.#{self.format}"
        end
    end

    def thumbnail_file_path
        thumb_file_path = "./data/#{self.id}.thumb.#{self.format}"
        if File.file?(thumb_file_path)
            return thumb_file_path
        else
            return self.file_path
        end
    end

    def content
        if File.file?(self.file_path)
            parse_markdown(self.file_path)
        else
            ''
        end
    end

    def format
        val = @metadata.dig('format')
        val == nil ? 'md' : val
    end

    def title
        @metadata.dig('title')
    end

    def date
        @metadata.dig('date')
    end
end