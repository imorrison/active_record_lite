require 'json'

class Session
  def initialize(request)
    @request = request
    @data = Hash.new(0)
    find_rails_lite_cookie
  end

  def [](key)
    @data[key]
  end

  def []=(key, value)
    @data[key] = value
  end

  def store_session(response)
    response.cookies << WEBrick::Cookie.new('_rails_lite_app', @data.to_json)
  end

  def find_rails_lite_cookie
    found_cookie = @request.cookies.select {|c| c.name == "_rails_lite_app" }

    unless found_cookie.empty?
      # deserialize the cookie objects value 
      @data = JSON.parse(found_cookie[0].value)
    end
  end
end