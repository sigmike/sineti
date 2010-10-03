require 'httparty'
require 'json'

class Ganeti
  def initialize(cluster, port = 5080)
    @cluster = cluster
    @port = port
  end
  
  def convert_booleans(options)
    result = {}
    options.each do |name, value|
      case value
      when true
        value = 1
      when false
        value = 0
      when Hash
        value = convert_booleans(value)
      end
      result[name] = value
    end
    result
  end

  def request(method, uri, options = {})
    options = convert_booleans(options)
    response = HTTParty.send(method, "https://#@cluster:#@port#{uri}", options)
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
  
  def nodes(options = {})
    get('/2/nodes', options)
  end

  def node(id, options = {})
    get("/2/nodes/#{id}", options)
  end

  def instances(options = {})
    get('/2/instances', options)
  end

  def instance(id, options = {})
    get("/2/instances/#{id}", options)
  end
end
