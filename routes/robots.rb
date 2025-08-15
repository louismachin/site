def get_ai_robots_txt
  raw_uri = 'https://raw.githubusercontent.com/ai-robots-txt/ai.robots.txt/refs/heads/main/robots.txt'
  begin
    response = simple_get(raw_uri)
    return [] unless response.code == '200'
    return simple_get(raw_uri).body.split("\n")
  rescue
    return []
  end
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
