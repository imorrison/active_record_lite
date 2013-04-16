require 'active_support/core_ext'
require 'json'
require 'webrick'
require_relative '../lib/rails_lite'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html
server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

class StatusesController < ControllerBase
  def create
    render_content(params.to_json, "text/json")
  end

  def new
    render_content(render("new.html.erb"), "text/html")
  end

  def show
    render_content("status #{params[:id]}", "text/text")
  end
end

server.mount_proc '/' do |req, res|
  router = Router.new
  router.draw do
    get Regexp.new("^/statuses/(?<id>\\d+)$"), StatusesController, :show
    get Regexp.new("^/statuses/new$"), StatusesController, :new
    post Regexp.new("^/statuses"), StatusesController, :create
  end

  route = router.run(req, res)
end

server.start