get '/.env' do
  "Nice try!"
end

get %r{.*\.php.*} do
  status 404
  "Nice try!"
end

post %r{.*\.php.*} do
  status 404
  "Nice try!"
end
