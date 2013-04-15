require_relative './cookies'

class ControllerBase
  attr_accessor :session 

  def initialize(request, response)
    @request = request
    @response = response
    session 
    @response_built = false
  end

  def render_content(content, body_type)
    unless @response_built
      @response.content_type = body_type
      @response.body = content
      @response_built = true
    end
    @session.store_session(@response)
  end

  def redirect_to(url)
    @response.status = 302
    @response['location'] = url 

    @session.store_session(@response)
  end

  def session
    @session ||= Session.new(@request)
  end
end