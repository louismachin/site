get '/projects' do
    @copy = $default_copy.but(title: "Louis Machin — Projects")
    erb :projects, locals: { copy: @copy }
end

def self.get_project(path, &block)
    send(:get, "/project#{path}", &block)
end

get_project '/forest' do
    @copy = $default_copy.but(title: "Louis Machin — Forest")
    @forest = get_forest(*$env.forest_auth)
    erb :forest, locals: { copy: @copy, forest: @forest }
end

get_project '/music_reviews' do
    @copy = $default_copy.but(title: "Louis Machin — Music Reviews")
    @podiums_reviews = get_podiums_reviews
    erb :podiums_reviews, locals: { copy: @copy, podiums_reviews: @podiums_reviews }
end

get_project '/bad_photos' do
    @copy = $default_copy.but(title: "Louis Machin — Bad Photos")
    @bad_photos = get_bad_photos
    erb :bad_photos, locals: { copy: @copy, bad_photos: @bad_photos }
end

get_project '/astrology' do
    @copy = $default_copy.but(title: "Louis Machin — Astrology")
    erb :astrology, locals: { copy: @copy }
end

get_project '/temple3d' do
    @copy = $default_copy.but(title: "Louis Machin — Temple3D")
    erb :temple3d, locals: { copy: @copy }
end

get_project '/foot' do
    @copy = $default_copy.but(title: "Louis Machin — Foot")
    erb :foot, locals: { copy: @copy }
end

get_project '/programming_challenges' do
    @copy = $default_copy.but(title: "Louis Machin — Programming Challenges")
    @programming_challenges = get_programming_challenges
    erb :programming_challenges, locals: { copy: @copy }
end