get '/teapot' do
  status 418
  "I'm a teapot"
end

get '/ping' do
  "Pong!"
end

get '/ip' do
  client_ip = request.env['HTTP_X_FORWARDED_FOR'] || 
              request.env['HTTP_X_REAL_IP'] || 
              request.ip
  
  # X-Forwarded-For can contain multiple IPs, take the first one
  client_ip = client_ip.split(',').first.strip if client_ip.include?(',')
  
  "Your IP address is: #{client_ip}"
end

get '/api' do
  content_type :json
  routes = settings.routes
    .reject { |verb, _| verb.upcase == 'HEAD' }
    .flat_map { |verb, routes_array|
      routes_array.map { |route|
        { method: verb.upcase, path: route[0].to_s }
      }
    }
    .select { |r| r[:path].start_with?('/api/') }.to_json
end

get '/api/fizzbuzz.json' do
  n = params[:n].to_i
  if n
    result = ''
    result += 'FIZZ' if n % 3 == 0
    result += 'BUZZ' if n % 5 == 0
    status 200
    content_type :json
    { result: result == '' ? n : result }.to_json
  else
    status 400
    content_type :json
    { error: 'Must provide valid ?n= query argument.' }.to_json
  end
end

get '/api/backup.tar.gz' do
  protected!
  require 'tempfile'
  content_type 'application/gzip'
  attachment 'backup.tar.gz'
  temp_tar = Tempfile.new(['backup', '.tar.gz'])
  tar_command = "tar -czf #{temp_tar.path} -C #{settings.root} data environment.yml"
  system(tar_command)
  send_file temp_tar.path, type: 'application/gzip'
end

ALLOWED_EXTENSIONS = ['jpg']

get '/data/:file_name.:ext' do
  file_name = params[:file_name]
  ext = params[:ext]
  if ALLOWED_EXTENSIONS.include?(ext)
    file_path = "data/#{file_name}.#{ext}"
    if File.file?(file_path)
      send_file file_path
    else
      status 404
    end
  else
    status 401
  end
end

not_found do
  status 404
  @copy = $default_copy.but(title: "Louis Machin — 404")
  erb :not_found, locals: { copy: @copy }
end

get '/robots.txt' do
  content_type 'text/plain'
  <<~ROBOTS
    User-agent: AddSearchBot
    User-agent: AI2Bot
    User-agent: Ai2Bot-Dolma
    User-agent: aiHitBot
    User-agent: Amazonbot
    User-agent: Andibot
    User-agent: anthropic-ai
    User-agent: Applebot
    User-agent: Applebot-Extended
    User-agent: Awario
    User-agent: bedrockbot
    User-agent: bigsur.ai
    User-agent: Brightbot 1.0
    User-agent: Bytespider
    User-agent: CCBot
    User-agent: ChatGPT Agent
    User-agent: ChatGPT-User
    User-agent: Claude-SearchBot
    User-agent: Claude-User
    User-agent: Claude-Web
    User-agent: ClaudeBot
    User-agent: CloudVertexBot
    User-agent: cohere-ai
    User-agent: cohere-training-data-crawler
    User-agent: Cotoyogi
    User-agent: Crawlspace
    User-agent: Datenbank Crawler
    User-agent: Devin
    User-agent: Diffbot
    User-agent: DuckAssistBot
    User-agent: Echobot Bot
    User-agent: EchoboxBot
    User-agent: FacebookBot
    User-agent: facebookexternalhit
    User-agent: Factset_spyderbot
    User-agent: FirecrawlAgent
    User-agent: FriendlyCrawler
    User-agent: Gemini-Deep-Research
    User-agent: Google-CloudVertexBot
    User-agent: Google-Extended
    User-agent: GoogleAgent-Mariner
    User-agent: GoogleOther
    User-agent: GoogleOther-Image
    User-agent: GoogleOther-Video
    User-agent: GPTBot
    User-agent: iaskspider/2.0
    User-agent: ICC-Crawler
    User-agent: ImagesiftBot
    User-agent: img2dataset
    User-agent: ISSCyberRiskCrawler
    User-agent: Kangaroo Bot
    User-agent: LinerBot
    User-agent: meta-externalagent
    User-agent: Meta-ExternalAgent
    User-agent: meta-externalfetcher
    User-agent: Meta-ExternalFetcher
    User-agent: MistralAI-User
    User-agent: MistralAI-User/1.0
    User-agent: MyCentralAIScraperBot
    User-agent: netEstate Imprint Crawler
    User-agent: NovaAct
    User-agent: OAI-SearchBot
    User-agent: omgili
    User-agent: omgilibot
    User-agent: OpenAI
    User-agent: Operator
    User-agent: PanguBot
    User-agent: Panscient
    User-agent: panscient.com
    User-agent: Perplexity-User
    User-agent: PerplexityBot
    User-agent: PetalBot
    User-agent: PhindBot
    User-agent: Poseidon Research Crawler
    User-agent: QualifiedBot
    User-agent: QuillBot
    User-agent: quillbot.com
    User-agent: SBIntuitionsBot
    User-agent: Scrapy
    User-agent: SemrushBot-OCOB
    User-agent: SemrushBot-SWA
    User-agent: Sidetrade indexer bot
    User-agent: Thinkbot
    User-agent: TikTokSpider
    User-agent: Timpibot
    User-agent: VelenPublicWebCrawler
    User-agent: WARDBot
    User-agent: Webzio-Extended
    User-agent: wpbot
    User-agent: YaK
    User-agent: YandexAdditional
    User-agent: YandexAdditionalBot
    User-agent: YouBot
    Disallow: /

    User-agent: *
    Allow: /
    Disallow: /api/
  ROBOTS
end
