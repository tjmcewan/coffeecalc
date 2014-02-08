require 'sinatra'
require 'data_mapper'

DataMapper::Logger.new($stdout, :debug)
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/coffeecalc.db")

class Coffee
  include DataMapper::Resource
  property :id, Serial
  property :what, String, required: true
  property :cost, Decimal, required: true, default: 0.0
  property :who, String
end

DataMapper.finalize.auto_upgrade!

get '/' do
  @coffees = Coffee.all
  @total = total(@coffees)
  erb :index
end

get '/coffees/new' do
  Coffee.create!(params)
  @coffees = Coffee.all
  @total = total(@coffees)
  erb :index
  # redirect '/'
end

post '/coffees/new' do
  # params.to_s
  Coffee.create!(params)
  @coffees = Coffee.all
  @total = total(@coffees)
  erb :index
  # redirect '/'
end

def total(coffees)
  coffees.map(&:cost).reduce(:+)
end
