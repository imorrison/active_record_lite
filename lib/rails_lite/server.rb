require "webrick"
require_relative './controllerbase'

class MyController < ControllerBase
  def go
    
  end
end

server = WEBrick::HTTPServer.new(:Port => 8080)

server.mount_proc('/') do |request, response|


  mycontroller = MyController.new(request, response)

  mycontroller.render_content('Hello World!... well, just Ian...', 'text/text')
  # mycontroller.render_content(request.path, 'text/text')

  mycontroller.redirect_to(request.path)

end

trap('INT') { server.shutdown }

server.start
