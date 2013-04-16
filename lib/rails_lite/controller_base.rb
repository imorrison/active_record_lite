require 'active_support/core_ext'
require_relative './cookies'

require_relative 'params'

class ControllerBase
  include Params

  attr_accessor :session
  attr_reader :params 

  def initialize(request, response, params)
    @request = request
    @response = response
    session 
    @response_built = false
    @params = params
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

  def render(template_name)
    template = File.read("./views/#{template_name}")
    ERB.new(template).result(binding)
  end

  def invoke_action(action_name)
    self.send(action_name)
  end
end