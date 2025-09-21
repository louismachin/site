def parse_markdown(content)
  renderer = Redcarpet::Render::HTML.new(hard_wrap: true)
  markdown = Redcarpet::Markdown.new(renderer, autolink: true, fenced_code_blocks: true)

  content.gsub!(/^::(.+?)::$/) do
    "<div class=\"center\">#{Regexp.last_match(1).strip}</div>"
  end

  content.gsub!(/^["“]([\w\s\-']+):\s+(.+)/) do
    speaker = Regexp.last_match(1).strip
    quote_md = Regexp.last_match(2).strip
    quote_html = markdown.render(quote_md).strip

    %Q(<table class="oration"><tr><td class="a">#{speaker}</td><td class="b">#{quote_html}</td></tr></table>)
  end

  markdown.render(content)
end

helpers do
  def render_markdown(uri)
    begin
      content = simple_get(uri).body
      content = content.force_encoding('UTF-8')
      parse_markdown(content)
    rescue => e
      puts e
      ''
    end
  end
end