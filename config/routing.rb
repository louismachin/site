helpers do
    def render_page(title: nil, key: nil, layout: nil, style: nil)
        @copy = $default_copy.but(title: title)
        erb :page, locals: { key: key, layout: layout, style: style, }
    end
end

before '*.json' do
    content_type :json
end

before '*.txt' do
    content_type 'text/plain'
end