get '/' do
  @copy = { title: "Louis Machin", description: "A website that contains my ramblings and other bits and bobs." }
  @content = get_home_content
  erb :home, locals: { copy: @copy, content: @content }
end