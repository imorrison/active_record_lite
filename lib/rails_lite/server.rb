require "webrick"
require_relative './controller_base'
require_relative './cookies'

class MyController < ControllerBase

  def go
    if @request.path == '/redirect'
      redirect_to("http://www.google.com")
    else
      @number = 6
      render_content(render("test.html.erb"), 'text/text')
    end
  end
end

server = WEBrick::HTTPServer.new(:Port => 8080)

server.mount_proc('/') do |request, response|

  mycontroller = MyController.new(request, response).go
  
  # mycontroller.redirect_to(request.path)
  # mycontroller.render_content('Hello World!... well, just Ian...', 'text/text')
  # mycontroller.render_content(response.body, 'text/text')
end

trap('INT') { server.shutdown }

server.start
