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
    # find the first route that matches
    match = @routes.select {|route| request_path =~ route.pattern }.first
  end

  def run(req, res)
    # get the name of the controller class form the matched route
    route = match(req.path) 
    if route
      route.controller_class.new(req, res).invoke_action(route.action_name)  
    else
      # route does not exist
      res.status = 404
    end   
  end
end










