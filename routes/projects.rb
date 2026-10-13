get '/projects' do
    render_page(title: 'Louis Machin — Projects', key: 'projects')
end

def self.get_project(path, &block)
    send(:get, "/project#{path}", &block)
end

get_project '/forest' do
    @forest = get_forest(*$env.forest_auth)
    render_page(title: 'Louis Machin — Forest', key: 'forest')
end

get_project '/bad_photos' do
    @bad_photos = get_bad_photos
    render_page(title: 'Louis Machin — Bad Photos', key: 'bad_photos')
end

get_project '/astrology' do
    render_page(title: 'Louis Machin — Astrology', key: 'astrology')
end

get_project '/temple3d' do
    render_page(title: 'Louis Machin — Temple3D', key: 'temple3d', layout: 'vert', style: 'width: 800px;')
end

get_project '/foot' do
    render_page(title: 'Louis Machin — Foot', key: 'foot', style: 'width: 800px;')
end

get_project '/programming_challenges' do
    @programming_challenges = get_programming_challenges
    render_page(title: 'Louis Machin — Programming Challenges', key: 'programming_challenges')
end

get_project '/garmin' do
    @data = $garmin_data
    render_page(title: 'Louis Machin — Garmin', key: 'garmin')
end