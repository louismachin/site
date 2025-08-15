$ai_rtxt_cache = nil

def get_ai_robots_txt
  return $ai_rtxt_cache.data if $ai_rtxt_cache && (Time.now - $ai_rtxt_cache.cached_at < 3600)
  raw_uri = 'https://raw.githubusercontent.com/ai-robots-txt/ai.robots.txt/refs/heads/main/robots.txt'
  begin
    response = simple_get(raw_uri)
    data = response.code == '200' ? response.body.split("\n") : []
  rescue
    data = []
  end
  $ai_rtxt_cache = Cache.new(Time.now, data)
  return data
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
