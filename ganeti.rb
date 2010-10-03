require 'httparty'
require 'json'

class Ganeti
  def initialize(cluster, port = 5080)
    @cluster = cluster
    @port = port
  end

  def request(method, uri, options = {})
    response = HTTParty.send(method, "https://#@cluster:#@port#{uri}")
    JSON.load(response.body)
  end
  
  def get(uri, parameters = {})
    request(:get, uri, :query => parameters)
  end

  def put(uri, data)
    request(:put, uri, :body => data)
  end
  
  def post(uri, data)
    request(:post, uri, :body => data)
  end
  
  def info
    get('/2/info')
  end
end
