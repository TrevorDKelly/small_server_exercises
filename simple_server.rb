require "socket"

def parse_request(request_line)
  parsed_line = request_line.split(/[ \?\&]/)
  method = parsed_line[0]
  path = parsed_line[1]
  protocol = parsed_line[-1]
  parameters = parsed_line[2..-2].each_with_object({}) do |pair, hash|
    name, value = pair.split('=')
    hash[name] = value
  end

  [method, path, parameters, protocol]
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

  method, path, parameters, protocol = parse_request(request_line)

  client.puts "HTTP/1.0 200 OK"
  client.puts "Content-Type: text/html"
  client.puts ""
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts method
  client.puts path
  client.puts parameters
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"

  number = parameters['number'].to_i

  client.puts "<p>The current number is #{number}</p>"

  client.puts "<a href='?number=#{number + 1}'>Add One</a>"
  client.puts "<a href='?number=#{number - 1}'>Subtract One</a>"

  client.puts "</body>"
  client.puts "</html>"

  client.close
end

