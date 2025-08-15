require 'sinatra'
require 'redcarpet'

require_relative './models/environment'

APP_ROOT = File.expand_path(__dir__)

configure do
    set :bind, '0.0.0.0'
    set :port, $env.port
    set :public_folder, File.expand_path('public', __dir__)
    set :environment, :production if $env.is_production?
    disable :protection
end

require_relative './helpers/markdown'
require_relative './helpers/content'
require_relative './helpers/simple_web'
require_relative './helpers/forest'
require_relative './helpers/cipher'
# require_relative './helpers/music'

require_relative './models/copy'
require_relative './models/document'
require_relative './models/guestbook'

require_relative './routes/index'
require_relative './routes/system'
require_relative './routes/spam'
require_relative './routes/robots'
require_relative './routes/upload'
require_relative './routes/session'
require_relative './routes/write'
require_relative './routes/read'
require_relative './routes/guestbook'
require_relative './routes/astrology'
require_relative './routes/projects'
require_relative './routes/time'
require_relative './routes/rss'
