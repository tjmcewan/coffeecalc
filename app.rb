require 'sinatra'

$coffees = []

get '/' do
  $coffees << params if params[:what]
  """
  <html><head><title>coffee calc</title></head>
  <body>
    <form action='/' method='get'>
      What: <input name='what'>
      Cost: <input name='cost'>
      Who: <input name='who'>
      <button type='submit'>add coffee</button>
    </form>
    #{coffees}
  </body></html>
  """
end

def coffees
  $coffees.map { |coffee|
    "<div>" + coffee.values.join(' - ') + "</div>"
  }.join('<br>')
end
