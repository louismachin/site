require 'sinatra'
require 'redcarpet'

require_relative './models/environment'

set :port, $env.port
set :public_folder, File.expand_path('public', __dir__)

require_relative './helpers/markdown'

require_relative './helpers/simple_web'

require_relative './models/document'

require_relative './routes/index'
require_relative './routes/system'
require_relative './routes/session'

require_relative './routes/astrology'