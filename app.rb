require 'sinatra'
require 'data_mapper'

@@coffees ||= []

get '/' do
  """
  <html>
  <head><title>coffee calc</title></head>
  <body>
    <form action='/' method='post'>
      What: <input name='what'>
      Cost: <input name='cost'>
      Who: <input name='who'>
      <button type='submit'>add coffee</button>
    </form>
    #{coffees}
  </body>
  </html>
  """
end

post '/' do
  @@coffees << params
  redirect '/'
end


def coffees
  @@coffees.map { |coffee|
    "<div>" + coffee.values.join(' - ') + "</div>"
  }.join('<br>')
end
