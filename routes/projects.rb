get '/project/forest' do
    @copy = $default_copy.but(title: "Louis Machin — Forest")
    @forest = get_forest(*$env.forest_auth)
    erb :forest, locals: {
        copy: @copy, forest: @forest,
    }
end