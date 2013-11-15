require 'socket'

host = '127.0.0.1'
port = '8080'

def timeit
  beginning_time = Time.now
  yield
  end_time = Time.now
  puts "Time elapsed #{(end_time - beginning_time)} seconds"
end

puts 'on nonblock tcp'

timeit do
  socket = TCPSocket.new(host, port)
  path = '/'
  request = "GET #{path} HTTP/1.0\r\n\r\n"
  socket.sendmsg_nonblock(request)
  socket.close
end

puts 'on blocking http'

timeit do
  require 'net/http'

  uri = URI.parse("http://localhost:8080/")
  response = Net::HTTP.get_response(uri)
end

# timeout=30.0
# ready = IO.select([@socket], nil, nil, timeout)

# if ready
#   path = '/'
#   request = "GET #{path} HTTP/1.0\r\n\r\n"
#   @socket.sendmsg_nonblock(request)
#   @socket.close
#   # response = @socket.recv(SOCKET_READ_SIZE)
# else
#   message = "Socket communications timed out after #{timeout} seconds"
#   logger.error message
#   @socket.close if @socket.present?
#   raise message
# end
