class BadPhoto
    def initialize(filename)
        @filename = filename
    end

    def id
        return @filename
    end

    def uri
        return "https://cdn.louismachin.com/download/public/bad_photos/" + @filename
    end

    def kodak?
        return @filename.start_with?("PICT")
    end

    def nokia?
        return @filename.start_with?("Photo")
    end

    def is_public?
        return true
    end

    def is_picture?
        return true
    end

    def title
        return 'Bad Photo'
    end
end