helpers do
    def render_page(title: nil, key: nil, layout: nil, style: nil)
        @copy = $default_copy.but(title: title)
        halt erb :page, locals: { key: key, layout: layout, style: style, }
    end
end

before '*.json' do
    content_type :json
end

before '*.txt' do
    content_type 'text/plain'
end

def self.get_project(path, &block)
    send(:get, "/project#{path}", &block)
end