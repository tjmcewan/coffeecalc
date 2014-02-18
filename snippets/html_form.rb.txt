require "sinatra"
require "sinatra/reloader"

get "/" do
  """
  <html>
  <body>
    <form action='/' method='get'>
      What: <input name='what'>
      Cost: <input name='cost'>
      <button type='submit'>add coffee</button>
    </form>
    <!-- coffees go here -->
  </body>
  </html>
  """
end
