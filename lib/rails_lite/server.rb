require "webrick"

server = WEBrick::HTTPServer.new(:Port => 8080)

server.mount_proc('/') do |request, response|

response.body = 'Hello World!... well, just Ian...'
response.content_type = 'text/text'

end

trap('INT') { server.shutdown }

server.start