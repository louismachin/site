ENV_FILE_PATH = 'environment.yml'

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

    def auth_key
        @data.dig('auth_key')
    end

    def new_token
        token = Array.new(12) { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join
        @given_tokens << token
        token
    end
end

$env = Environment.new