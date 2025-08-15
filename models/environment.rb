ENV_FILE_PATH = 'environment.yml'

Cache = Struct.new(:cached_at, :data, :expiry) do
  def expired?
    Time.now - cached_at > expiry
  end
end

class Environment
    attr_reader :data
    attr_accessor :given_tokens

    def initialize
        if File.file?(ENV_FILE_PATH)
            require 'yaml'
            @data = YAML.load_file(ENV_FILE_PATH)
            @given_tokens = []
        else
            puts "ERROR: 'environment.yml' file is missing..."
            exit
        end
    end

    def base_url
        @data.dig('base_url')
    end

    def port
        @data.dig('port')
    end

    def is_production?
        @data.dig('production')
    end

    def auth_key
        @data.dig('auth_key')
    end

    def new_token
        token = Array.new(12) { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join
        @given_tokens << token
        token
    end

    def forest_auth
        [
            @data.dig('third_parties', 'forest', 'seekruid'),
            @data.dig('third_parties', 'forest', 'remember_token'),
        ]
    end
end

$env = Environment.new
