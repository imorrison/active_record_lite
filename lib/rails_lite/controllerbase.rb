class ControllerBase
  def initialize(request, response)
    @request = request
    @response = response
    #@response_built = false
  end

  def render_content(content, body_type)

    @response.content_type = body_type
    @response.body = content
  
    @response_built = true
  end

  def redirect_to(url)
    # need to fill in the body!
    @response.status = 302
    @response['location'] = url  
  end
end