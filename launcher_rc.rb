
# Add a new hook that will be called as a Jetty server is prepared.
# Each hook will be called with:
#
#   hook.call(server, port, [{:war => '/path/to/app.war', :path => '/uri'}, ...])
#
# Nothing uses this feature by default, but you could use it for performing
# further configuration on the Jetty server object (such as sizing thread pools)
# by adding a hook from code in your ASPACE_LAUNCHER_BASE/launcher_rc.rb file.


puts "****************** add server prepare hook ************************"

add_server_prepare_hook( lambda { |server, port, rest|  
  puts "********************** calling server_prepare_hook ****************" 
  puts server, port, rest
  if rest[0][:war] && rest[0][:war].end_with?("frontend.war")
    puts "****** Connectors: Req Hdr, Bfr, Res Hdr, Bfr  sizes ***** "
    server.getConnectors().each do |c|  
      puts c, c.getRequestHeaderSize, c.getRequestBufferSize, c.getResponseHeaderSize, c.getResponseBufferSize
      c.setRequestHeaderSize(8192*2)
      c.setResponseHeaderSize(8291*2)
      puts c, c.getRequestHeaderSize, c.getRequestBufferSize, c.getResponseHeaderSize, c.getResponseBufferSize    
    end    
  end
  puts "********** end server_prepare_hook **********"
  })
