get '/' do
    @copy = $default_copy
    @content = get_home_content
    erb :home, locals: { copy: @copy, content: @content }
end

get '/cv' do
    redirect '/cv.pdf'
end