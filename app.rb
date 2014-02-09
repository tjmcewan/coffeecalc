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
  Coffee.create!(params) if params[:what]
  @coffees = Coffee.all
  @total = total(@coffees)
  erb :index
end

def total(coffees)
  coffees.map(&:cost).reduce(:+)
end
