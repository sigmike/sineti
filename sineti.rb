require 'rubygems'
require 'sinatra'
require 'compass'
require 'ganeti'

configure do
  CLUSTER = YAML.load(File.read('cluster.yml'))

  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views'
  end

  set :haml, { :format => :html5 }
  set :sass, Compass.sass_engine_options
end

helpers do
  def partial(name, locals = {})
    haml "partials/#{name}".to_sym, :locals => locals, :layout => false
  end
end

before do
  @ganeti = Ganeti.new(CLUSTER["hostname"])
end

get '/screen.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :screen
end

get '/' do
  redirect '/cluster/info'
end

get '/:object/:action' do |object, action|
  haml "#{object}/#{action}".to_sym
end

get '/:object/:action/:id' do |object, action, id|
  haml "#{object}/#{action}".to_sym, :locals => {:id => id}
end
