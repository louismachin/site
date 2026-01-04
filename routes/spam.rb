get '/.env' do
    status 418
    "Nice try, I'm just a teapot!"
end

get '/*.php' do
    status 418
    "I'm a teapot, not a PHP server!"
end

post '/*.php' do
    status 418
    "I'm a teapot, not a PHP server!"
end