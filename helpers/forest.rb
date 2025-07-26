def forest_app_tree_lookup(id)
    trees = {
        "0" => "Cedar",
        "1" => "Flower Tree",
        "2" => "Treehouse",
        "3" => "Nest",
        "4" => "Lemon Tree",
        "5" => "Triplets",
        "6" => "Bush",
        "7" => "Octopus",
        "8" => "Cherry Blossom",
        "9" => "Coconut Tree",
        "10" => "Kitty",
        "11" => "Flourishing Grass",
        "12" => "Chinese Pine Tree",
        "13" => "Ball Cactus",
        "14" => "Pumpkin",
        "15" => "Scarecrow",
        "16" => "Christmas Tree",
        "17" => "Old Chinese Bamboo",
        "18" => "Mushroom",
        "19" => "Cactus",
        "20" => "Ginkgo Tree",
        "21" => "Wisteria Tree",
        "22" => "Watermelon",
        "23" => "Bamboo",
        "24" => "Candy Tree",

        "25" => "Sunflower",
        "26" => "Rose",
        "27" => "Maple Tree",
        "28" => "Baobab Tree",
        "29" => "Rafflesia",
        "30" => "Banana Tree",
        "31" => "Chinese Bamboo",
        "32" => "Earth Day Tree",
        "33" => "Carnation",
        "34" => "Apple Tree",
        "35" => "Starry Tree",
        "36" => "Cuckoo Clock",
        "37" => "Moon Tree",
        "38" => "Rainbow Flower",
        "39" => "Ghost Mushroom",
        "40" => "Blue Oak Tree",
        "41" => "Oak Tree",
        "42" => "Pink Oak Tree",
        "43" => "Yellow Oak Tree",
        "44" => "Purple Oak Tree",
        "45" => "Cat-tail Willow",
        "46" => "Blue Flower",
        "47" => "Star Coral",
        "48" => "Chocolate Strawberry Cake",
        "49" => "Cherry Cheese Cake",
        "50" => "Tiramisu",
        "51" => "Matcha Azuki Cake",
        "52" => "Lemon Cake",
        "53" => "Black Forest Cake",
        "54" => "Blueberry Cake",
        "55" => "Strawberry Chiffon Cake",
        "56" => "Cake Tree",
        "57" => "Doggo Tree",
        "58" => "Bear's Paw",
        "59" => "Starburst Tree",
        "60" => "Unicorn Tree",
        "61" => "Space Tree",
        "62" => "Celestial Tree",
        "63" => "Weeping Willow",
        "64" => "Four-Leaf Clover",
        "65" => "Forest Spirit",
        "66" => "6th Anniversary Cake Tree",
        "67" => "Water Spirit",
        "68" => "Sundae Tree",
        "69" => "Lover Tree",
        "70" => "Pear Tree House",
        "71" => "Witch Mushroom",
        "72" => "Lily Flower",
        "73" => "Twilight Guardian",
        "74" => "Tulip",
        "75" => "Plum Blossom",
        "76" => "Camellia",
        "77" => "Luminie",
        "78" => "7th Anniversary Cake Tree",
        "79" => "Lavender",
        "80" => "Rice",
        "81" => "Statue of Tada",
        "82" => "Golden Wings",
        "83" => "Osmanthus",
        "84" => "Cosmos",
        "85" => "Wishing Tree",
        "86" => "Lantern Flower",
        "87" => "Narcissus",
        "88" => "#tinytan 1",
        "89" => "#tinytan 2",
        "90" => "#tinytan 3",
        "91" => "#tinytan 4",
        "92" => "#tinytan 5",
        "93" => "#tinytan 6",
        "94" => "#tinytan 7",
        "95" => "8th Anniversary Cake Tree",
        "96" => "Lotus",
        "97" => "Tangerine Tree",
        "98" => "Golden Trumpet Tree",
        "99" => "9th Anniversary Cake Tree",
    }
    return trees[id] || 'Unknown Tree'
end

def forest_app_profile(seekruid, remember_token)
    base_uri = 'https://c88fef96.forestapp.cc'
    route = "/api/v1/users/#{seekruid}/profile"
    simple_get_body(base_uri + route, {
        :seekruid => seekruid,
    })
end

def forest_app_tags(seekruid, remember_token)
    base_uri = 'https://c88fef96.forestapp.cc'
    route = "/api/v1/tags"
    simple_get_body(base_uri + route, {
        :seekruid => seekruid,
    }, {
        'Cookie' => "remember_token=#{remember_token}",
    })
end

def forest_app_timelines(seekruid, remember_token)
    base_uri = 'https://c88fef96.forestapp.cc'
    route = "/api/v1/timelines"
    start_date = '1970-01-01T00:00:00.000Z'
    end_date = Time.now.strftime('%Y-%m-%dT%H:%M:%S.000Z')
    simple_get_body(base_uri + route, {
        :end_date => end_date,
        :start_date => start_date,
        :seekruid => seekruid,
    }, {
        'Cookie' => "remember_token=#{remember_token}",
    })
end

def forest_app_rewarded_trees(seekruid, remember_token)
    forest_app_timelines(seekruid, remember_token)['achievement_states']
        .select { |achievement| achievement['state'] == 'rewarded' }
end

def forest_app_plants(seekruid, remember_token)
    base_uri = 'https://c88fef96.forestapp.cc'
    route = "/api/v1/plants/updated_plants"
    update_since = '1970-01-01T00:00:00.000Z'
    simple_get_body(base_uri + route, {
        :update_since => update_since,
        :seekruid => seekruid,
    }, {
        'Cookie' => "remember_token=#{remember_token}",
    })
end

Plant = Struct.new(:type, :image, :note, :tag, :start_time, :end_time)

def get_forest(seekruid, remember_token)
    tags = {}
    forest_app_tags(seekruid, remember_token)['tags']
        .each { |tag| tags[tag['tag_id']] = tag['title'] }
    forest_app_plants(seekruid, remember_token)['plants']
        .select { |plant| plant['is_success'] }
        .map { |plant|
            Plant.new(
                forest_app_tree_lookup(plant['tree_type_gid'].to_s),
                "/img/forest_app/#{plant['tree_type_gid']}.png",
                plant['note'],
                tags[plant['tag']],
                Time.parse(plant['start_time']),
                Time.parse(plant['end_time']),
            )
        }
        .sort { |a, b| b.end_time <=> a.end_time }
end