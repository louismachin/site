GITHUB_USER, GITHUB_REPO, GITHUB_BRANCH = 'louismachin', 'problems', 'main'
LANGUAGES = { '.rb' => 'Ruby', '.py' => 'Python', '.js' => 'JavaScript' } # to expand as used...

ProgrammingChallenge = Struct.new(:name, :category, :subcategory, :url, :language, :path) do
    def raw_url
        "https://raw.githubusercontent.com/#{GITHUB_USER}/#{GITHUB_REPO}/#{GITHUB_BRANCH}/#{path}"
    end

    def raw_code
        @raw_code ||= begin
            res = simple_get(raw_url)
            res.code == '200' ? res.body.force_encoding('UTF-8').lines.map(&:chomp) : []
        end
    end
end

$pc_category_names_cache = nil

def get_category_names
    return $pc_category_names_cache unless $pc_category_names_cache.nil?
    response = simple_get("https://raw.githubusercontent.com/#{GITHUB_USER}/#{GITHUB_REPO}/#{GITHUB_BRANCH}/names.yml")
    result = response.code == '200' ? (YAML.safe_load(response.body) || {}) : {}
    $pc_category_names_cache = result
    return result
end

$programming_challenges_cache = nil

def get_programming_challenges
    return $programming_challenges_cache unless $programming_challenges_cache.nil?
    names = get_category_names
    tree = simple_get_body(
        "https://api.github.com/repos/#{GITHUB_USER}/#{GITHUB_REPO}/git/trees/#{GITHUB_BRANCH}",
        { recursive: 1 },
        { 'Accept' => 'application/vnd.github+json' }
    )
    result = (tree['tree'] || []).filter_map { |item|
        next unless item['type'] == 'blob'
        path, language = item['path'], LANGUAGES[File.extname(item['path'])]
        next if language.nil? # skips .txt inputs, README, names.yml etc.
        folders = File.dirname(path).split('/')
        next if folders == ['.'] # ignore code files in the repo root
        ProgrammingChallenge.new(
            File.basename(path, '.*'),
            names.fetch(folders[0], folders[0]),
            folders[1..].empty? ? nil : folders[1..].join('/'),
            "https://github.com/#{GITHUB_USER}/#{GITHUB_REPO}/blob/#{GITHUB_BRANCH}/#{path}",
            language,
            path
        )
    }.sort_by { |c| [c.category, c.subcategory.to_s, c.name.to_i, c.name] }
    $programming_challenges_cache = result
    return result
end


def reload_programming_challenges
	$programming_challenges_cache = nil
	$pc_category_names_cache = nil
end

$reloaders << method(:reload_programming_challenges)