require 'sinatra'
require 'redcarpet'

require_relative './models/environment'

APP_ROOT = File.expand_path(__dir__)

set :bind, '0.0.0.0'
set :port, $env.port
set :public_folder, File.expand_path('public', __dir__)

require_relative './helpers/markdown'
require_relative './helpers/content'
require_relative './helpers/simple_web'
# require_relative './helpers/music'

require_relative './models/document'
require_relative './models/guestbook'

require_relative './routes/index'
require_relative './routes/system'
require_relative './routes/upload'
require_relative './routes/session'
require_relative './routes/content'
require_relative './routes/guestbook'
require_relative './routes/astrology'
require_relative './routes/time'
require_relative './routes/rss'