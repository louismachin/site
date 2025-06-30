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

def thelemic_date(time = Time.now)
    query = time.strftime("%Y-%m-%d %H:%M:%S").gsub(' ', '%20')
    uri = "https://date.eralegis.info/#{query}.json"
    response = simple_get(uri)
    if response.code == '200'
        body = JSON.parse(response.body)
        body['sol']['symbol'] = THELEMIC_DATE_SIGNS[body['sol']['sign']]
        body['luna']['symbol'] = THELEMIC_DATE_SIGNS[body['luna']['sign']]
        body['en'] = [
            THELEMIC_DATE_ROMAN[body['year'][0]].upcase,
            THELEMIC_DATE_ROMAN[body['year'][1]]
        ].join(':')
        body['plain'] = {
            full: body['plain'],
            sol: body['plain'].split(' : ')[0],
            luna: body['plain'].split(' : ')[1],
            day: body['plain'].split(' : ')[2],
            year: body['plain'].split(' : ')[3],
            year_alt: "Anno #{body['en']} e.n.",
        }
        body['readme'] = 'This functionality is powered by https://eralegis.info'
        return body
    else
        return { error: 'Could not get the Thelemic date' }
    end
end

get '/api/thelemic_date.json' do
    content_type :json
    thelemic_date.to_json
end