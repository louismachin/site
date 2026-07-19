THELEMIC_DATE_SIGNS = [
    '♈︎', '♉︎', '♊︎', '♋︎', '♌︎', '♍︎', '♎︎', '♏︎', '♐︎', '♑︎', '♒︎', '♓︎',
]
THELEMIC_DATE_DAYS = [
    '☽︎', '♂︎', '☿︎', '♃︎', '♀︎', '♄︎', '☉︎',
]
THELEMIC_DATE_ROMAN = [
    '0', 'i', 'ii', 'iii', 'iv', 'v', 'vi', 'vii', 'viii', 'ix', 'x', 'xi',
    'xii', 'xiii', 'xiv', 'xv', 'xvi', 'xvii', 'xviii', 'xix', 'xx', 'xxi', 'xxii',
]

$thelemic_date_cache = nil
$thelemic_date_cached_at = nil
$thelemic_date_cache_expiry = 10 * 60 # 10 minutes

def thelemic_date(time = Time.now)
    if $thelemic_date_cache
        elapsed_seconds = Time.now - $thelemic_date_cached_at
        if elapsed_seconds < $thelemic_date_cache_expiry
            return $thelemic_date_cache
        end
    end
    query = time.strftime("%Y-%m-%d %H:%M:%S").gsub(' ', '%20')
    uri = "https://jyot.io/api/thelemic_date.json"
    response = simple_get(uri)
    if response.code == '200'
        body = JSON.parse(response.body)
        body['readme'] = 'This functionality is powered by https://jyot.io'
        $thelemic_date_cache = body
        $thelemic_date_cached_at = Time.now
        return body
    else
        return { error: 'Could not get the Thelemic date' }
    end
rescue
    return { error: 'Could not get the Thelemic date' }
end

get '/api/thelemic_date.json' do
    content_type :json
    thelemic_date.to_json
end

helpers do
    def nav_sol_date_str
        return thelemic_date['sol']
    rescue
        return ''
    end

    def nav_luna_date_str
        return thelemic_date['luna']
    rescue
        return ''
    end
end