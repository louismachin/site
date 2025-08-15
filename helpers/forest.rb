def forest_app_tree_lookup(id)
    trees = {
        "71" => "Witch Mushroom",
        "114" => "Wishing Flower",
        "59" => "StarBurst Flower",
        "17" => "Old Chinese Bamboo",
        "66" => "Birthday 2020 Tree",
        "69" => "Lover Tree",
        "67" => "Aqua Tree",
        "64" => "Clover",
        "54" => "Blueberry cake",
        "53" => "Black Forest cake",
        "52" => "Lemon Cake",
        "51" => "Mocha Redbean Cake",
        "49" => "Cherry Cheesecake",
        "48" => "Strawberry Chocolate cake",
        "61" => "Universe Tree",
        "60" => "Unicorn",
        "57" => "Doggy Tree",
        "56" => "Birthday 2019 Cake Tree",
        "46" => "Small Blue Flower",
        "45" => "Cat-tail Willow",
        "44" => "Purple Oak Tree",
        "43" => "Yellow Oak Tree",
        "40" => "Blue Oak Tree",
        "39" => "Ghost Mushroom",
        "38" => "Rainbow Flower",
        "36" => "Time Tree",
        "35" => "Star Tree",
        "31" => "Chinese Bamboo",
        "29" => "Rafflesia",
        "28" => "Baobab Tree",
        "26" => "Rose",
        "24" => "Candy Tree",
        "23" => "Bamboo",
        "20" => "Ginkgo Tree",
        "19" => "Cactus",
        "15" => "Scarecrow",
        "14" => "Pumpkin",
        "13" => "Cactus Ball",
        "12" => "Pine Tree",
        "11" => "Grass",
        "10" => "Cat Tree",
        "9" => "Coconut Tree",
        "8" => "Cherry Blossom",
        "7" => "Octopus",
        "4" => "Lemon Tree",
        "1" => "Flower Tree",
        "6" => "Bush",
        "0" => "Cedar",
        "2" => "Treehouse",
        "3" => "Nest",
        "21" => "Wisteria Tree",
        "22" => "Watermelon",
        "25" => "Sunflower",
        "30" => "Banana Tree",
        "33" => "Carnation",
        "34" => "Apple Tree",
        "37" => "Moon Tree",
        "41" => "Green Oak Tree",
        "42" => "Pink Oak Tree",
        "47" => "Star Coral",
        "50" => "Tiramisu",
        "58" => "Bear's Paw",
        "62" => "Celestial Tree",
        "63" => "Weeping Willow",
        "65" => "Eco Tree",
        "68" => "Sundae Tree",
        "32" => "Earth Bush",
        "18" => "Mushroom",
        "5" => "Triplets",
        "27" => "Maple Tree",
        "55" => "Strawberry Chiffon cake",
        "70" => "Pear Tree House",
        "72" => "Lily Tree",
        "73" => "Christmas Tree 2020",
        "74" => "Tulip",
        "75" => "Plum Blossom",
        "76" => "Camellia",
        "77" => "Luminie",
        "78" => "Birthday 2021",
        "80" => "Rice",
        "79" => "Lavender",
        "82" => "Golden Wings",
        "83" => "Osmanthus",
        "81" => "Statue of Tada",
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
        "95" => "Birthday 2022 Tree",
        "96" => "Lotus",
        "97" => "Tangerine",
        "99" => "Birthday 2023",
        "100" => "Jacaranda",
        "103" => "10th anniversary cake tree",
        "104" => "Jacaranda fairy",
        "105" => "Geraniums fairy",
        "106" => "Monstera",
        "107" => "Mooncake Tree",
        "108" => "Cloud Moon Tree",
        "101" => "Geranium",
        "109" => "Spooky Tree",
        "110" => "Snowflake Bush",
        "115" => "Butterfly Orchid",
        "111" => "Christmas Tree 2024",
        "112" => "Mistletoe",
        "113" => "Calla Lily",
        "98" => "Golden Trumpet Tree",
        "16" => "Christmas Tree 2016",
        "117" => "White Rose",
        "118" => "Irises",
        "119" => "Money Tree",
        "120" => "Gold Ingot Succulents",
        "121" => "Corn Poppy",
        "116" => "Lisianthus",
        "122" => "Juliet Rose",
        "123" => "Cyclamen",
        "124" => "Bell Flower",
        "125" => "Oncidium",
        "126" => "Epiphyllum",
        "127" => "Common Aoricot",
        "128" => "Snapdragon",
        "129" => "Hyacinth",
        "130" => "Dahlia",
        "131" => "Calendula",
        "132" => "2025 EarthDay",
        "133" => "2025 Birthday\t",
        "134" => "鹿角蕨",
        "135" => "天堂鳥",
        "136" => "杜鵑花",
        "137" => "月季",
        "138" => "石蒜",
        "139" => "長壽花",
        "140" => "菊花",
        "141" => "芙蓉",
        "142" => "鳳凰木",
        "143" => "彩虹桉",
        "144" => "補蠅草",
    }
    return trees[id] || "Unknown Tree (#{id})"
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