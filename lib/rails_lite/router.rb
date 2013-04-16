require_relative 'params'

class Route
  attr_reader :verb, :pattern, :controller_class, :action_name
  def initialize(verb, pattern, controller_class, action_name)
    @verb = verb
    @pattern = pattern
    @controller_class = controller_class
    @action_name = action_name
  end
  
  def matches?(req)
    @verb == req.downcase.to_sym
  end  
end

class Router
  include Params

  def initialize
    @routes = []
  end

  def add_route(route)
    @routes << route
  end 
  
  [:get, :post, :put, :delete].each do |verb|
     define_method(verb) do |pattern, controller_class, action_name|
       verb_name = verb 
       add_route(Route.new(verb_name, pattern, controller_class, action_name))
     end
  end

  def draw(&block)
    self.instance_eval(&block)
  end

  def match(request_path)
    match_data = @routes.select {|route| request_path =~ route.pattern }.first
  end

  def run(req, res)
    route = match(req.path)
    if route
      # pass the params to the new controller
      params = parse(req, route.pattern)
      
      # add the body params, but only in a post
      if route.verb == :post
        body_params = parse_www_encoded_form(req.body)
        params = body_params
      end

      route.controller_class.new(req, res, params).invoke_action(route.action_name)  
    else
      res.status = 404
    end   
  end
end





