get '/project/forest' do
    @copy = $default_copy.but(title: "Louis Machin — Forest")
    @forest = get_forest(*$env.forest_auth)
    erb :forest, locals: {
        copy: @copy, forest: @forest,
    }
end

get '/project/music_reviews' do
    @copy = $default_copy.but(title: "Louis Machin — Music Reviews")
    @podiums_reviews = get_podiums_reviews
    erb :podiums_reviews, locals: {
        copy: @copy, podiums_reviews: @podiums_reviews,
    }
end

get '/project/bad_photos' do
    @copy = $default_copy.but(title: "Louis Machin — Bad Photos")
    @bad_photos = get_bad_photos
    erb :bad_photos, locals: {
        copy: @copy, bad_photos: @bad_photos,
    }
end