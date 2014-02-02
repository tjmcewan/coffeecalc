require 'sinatra'

get '/' do

"""
<html>
<head><title>coffee calc</title></head>
<body>
  <form action='/coffees/new' method='post'>
    <input name='coffee'>
    <button type='submit'>add coffee</button>
  </form>
</body>
</html>
"""

end

post '/coffees/new' do
  params.to_s
end
