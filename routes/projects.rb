get '/project/forest' do
    @copy = $default_copy.but(title: "Louis Machin — Forest")
    @forest = get_forest(*$env.forest_auth)
    erb :forest, locals: {
        copy: @copy, forest: @forest,
    }
end

get '/project/bad_photos' do
    @copy = $default_copy.but(title: "Louis Machin — Bad Photos")
    @filenames = get_bad_photos
    erb :bad_photos, locals: {
        copy: @copy, filenames: @filenames,
    }
end