class Route
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
     define_method(verb) do |verb, pattern, controller_class, action_name| 
       add_route(Route.new(verb, pattern, controller_class, action_name))
     end
  end
end