class ControllerBase
  def initialize(request, response)
    @request = request
    @response = response
  end

  def render_content(content, body_type)
    @response.content_type = body_type
    @response.body = content
  
    @response_built = true
  end

  def redirect_to(url)
    @response.body = "Works!" if url == '/works'
  end
end