require "sinatra"
require "sinatra/reloader"

$coffees = []

get "/" do
  $coffees << params
  """
  <html>
  <body>
    <form action='/' method='get'>
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
