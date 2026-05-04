$ai_rtxt_cache = nil

def get_ai_robots_txt
    return $ai_rtxt_cache.data if $ai_rtxt_cache && !$ai_rtxt_cache.expired?
    raw_uri = 'https://raw.githubusercontent.com/ai-robots-txt/ai.robots.txt/refs/heads/main/robots.txt'
    begin
        response = simple_get(raw_uri)
        if response.code == '200'
            $ai_rtxt_cache = Cache.new(Time.now, response.body.split("\n"), 3600)
        end
    rescue
        # keep existing cache if available, even if expired
    end
    $ai_rtxt_cache&.data || []
end

def get_robots_txt
    (get_ai_robots_txt + [
        "",
        "User-agent: *",
        "Allow: /",
        "Disallow: /api/"
    ]).join("\n")
end

get '/robots.txt' do
    content_type 'text/plain'
    get_robots_txt
end
