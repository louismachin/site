fastmail_api_key = $env.data.dig('third_parties', 'fastmail', 'api_key')
$fastmail = Fastmail.new(fastmail_api_key)