# This is a mockup of the FAHClient control connection, for testing only.
require 'socket'

class MockFahc
    def initialize(sockaddr, sockport)
        @cc_socket = TCPServer.open(sockport, sockaddr)
        @conn_details = Hash.new
        @connected_clients = Hash.new

        @conn_details[:server] = @cc_socket
        @conn_details[:clients] = @connected_clients

        @connection_index = 0
        puts 'Started Mock FAHC.....'
        run
    end

    def run
        loop {
            client_connection = @cc_socket.accept
            Thread.start(client_connection) do |conn|
                index = @connection_index
                @connection_index = @connection_index + 1
                puts "MockFAHC: #{Time.now}: connection established with client #{index}: #{conn}"
                conn.puts("Hello, Connection #{index}, from MockFahc at #{Time.now}")
                @conn_details[:clients][index] = conn
                server_loop(index, conn)
            end
        }.join
    end

    def server_loop(index, connection)
        loop do
            command = connection.gets.chomp
            puts "MockFAHC: from client #{index}: rx cmd: #{command}"
            cmdary = command.split
            case cmdary[0]
            when 'ping'
                connection.puts '0.0.0 Uh'
            when 'slot-info'
                connection.puts "\nPyON 1 slots\n[\n  {\n    \"id\": \"00\",\n    \"status\": \"Pretending\"\n  }\n]\n---\n> "
            else
                connection.puts '#{cmdary[0]}: command not implemented'
            end
        end
    end
end

MockFahc.new(36330, 'localhost')
