require "sinatra"
require "sinatra/reloader"

$coffees = []

get "/" do
  template
end

post "/" do
  $coffees << params
  redirect "/"
end

def template
  """
  <html>
  <body>
    <form action='/' method='post'>
      What: <input name='what'>
      Cost: <input name='cost'>
      <button type='submit'>add coffee</button>
    </form>
    #{ coffees_html }
  </body>
  </html>
  """
end

def coffees_html
  $coffees.map { |coffee|
    "<div>#{ coffee[:what] } $#{ coffee[:cost] }</div>"
  }.join("<br>")
end
