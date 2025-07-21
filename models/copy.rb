class Copy
    attr_accessor :title, :description, :image, :keywords

    def initialize
        @title = 'Louis Machin'
        @description = 'A website that contains my ramblings and other bits and bobs.'
        @image = '/img/embed_image.png'
        @keywords = %w(louis machin blog)
    end

    def but(title: nil, description: nil, image: nil, keywords: nil)
        copy = dup
        copy.title = title unless title.nil?
        copy.description = description unless description.nil?
        copy.image = image unless image.nil?
        copy.keywords = keywords unless keywords.nil?
        return copy
    end
end

$default_copy = Copy.new