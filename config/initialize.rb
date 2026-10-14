require 'sinatra'
require 'redcarpet'

require_relative '../models/environment'

APP_ROOT = File.expand_path('..', __dir__)

configure do
    set :bind, '0.0.0.0'
    set :port, $env.port
    set :views, File.expand_path('views')
    set :public_folder, File.expand_path('public')
    set :environment, :production if $env.is_production?
    disable :protection
end

$reloaders = [] # to iterate over with GET /api/reload.json

require_relative '../config/routing'
require_relative '../config/requirements'
require_relative '../config/on_startup'