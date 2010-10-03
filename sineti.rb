require 'rubygems'
require 'sinatra'
require 'ganeti'

configure do
  CLUSTER = YAML.load(File.read('cluster.yml'))
end

helpers do
  def partial(name, locals = {})
    haml "partials/#{name}".to_sym, :locals => locals, :layout => false
  end
end

before do
  @ganeti = Ganeti.new(CLUSTER["hostname"])
end

get '/' do
  haml :index
end
