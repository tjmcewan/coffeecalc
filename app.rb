require "sinatra"

$coffees = []

get "/" do
  $coffees << params
  """
  <html>
  <body>
    <form action='/' method='get'>
      What: <input name='what'>
      Cost: <input name='cost'>
      Who: <input name='who'>
      <button type='submit'>add coffee</button>
    </form>
    #{coffees_html}
  </body>
  </html>
  """
end

def coffees_html
  $coffees.map { |coffee|
    "<div>#{coffee[:what]} #{coffee[:who]} #{coffee[:cost]}</div>"
  }.join("<br>")
end
