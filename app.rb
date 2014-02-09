require 'sinatra'
require 'data_mapper'

@@coffees ||= []

get '/' do
  erb :index
end

post '/' do
  @@coffees << params
  redirect '/'
end
