require "socket"

server = TCPServer.new("localhost", 3003)

def parse_request(request_line)
  method, path_query, protocol = request_line.split
  path, query = path_query.split("?")
  query ? parameters = Hash[query.split("&").map { |kv| k, v = kv.split("=")}] : {}
  
  [method, path, parameters]
end

loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

  method, path, parameters = parse_request(request_line)

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html\r\n\r\n"
  client.puts "<html><body>"
  client.puts "<pre>"
  client.puts method
  client.puts path
  client.puts parameters
  client.puts "</pre>"

  client.puts "<h1>Rolls:</h1>"
  rolls = parameters["rolls"].to_i
  sides = parameters["sides"].to_i
  rolls.times { |i| client.puts("<p>", rand(sides) + 1, "</p>") }

  client.puts "</body></html>"
  client.close
end
