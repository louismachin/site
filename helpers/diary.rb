@latest_diary_sha256 = nil

def refresh_diary_from_cdn
    sha256 = cdn_sha256('/private/diary.tar.gz')
    return unless sha256
    return if @latest_diary_sha256 == sha256
    return unless cdn_download('/private/diary.tar.gz', './data/diary.tar.gz')
    FileUtils.mkdir_p('./data/diary')
    return unless system('tar', '-xzf', './data/diary.tar.gz', '-C', './data/diary', '--strip-components=1')
    @latest_diary_sha256 = sha256
end

DiaryEntry = Struct.new(:time, :astro, :text, keyword_init: true)

DIARY_HEADER = /\A[A-Z][a-z]{2}, [A-Z][a-z]{2} \d{1,2} \d{4} - \d{1,2}:\d{2} [AP]M\z/

def get_diary_entries(dir = './data/diary')
    refresh_diary_from_cdn

    entries = []

    Dir.glob(File.join(dir, '*.txt')).sort.each do |path|
        current = nil

        File.foreach(path, chomp: true, encoding: 'UTF-8') do |line|
            if DIARY_HEADER.match?(line.strip)
                entries << current if current
                current = DiaryEntry.new(
                    time:  Time.strptime(line.strip, '%a, %b %d %Y - %I:%M %p'),
                    astro: nil,
                    text:  []
                )
            elsif current
                if current.astro.nil? && current.text.empty? && line.start_with?('☉')
                    current.astro = line.strip
                else
                    current.text << line
                end
            end
        end

        entries << current if current
    end

    entries.each { |e| e.text = parse_markdown(e.text.join("\n").strip) }
    entries.sort_by(&:time)
end