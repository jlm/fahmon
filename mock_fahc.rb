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

        @updates = Array.new
        @percent = 0
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
            puts "MockFAHC: #{Time.now}: from client #{index}: rx cmd: #{command}"
            process_cmd(command, connection, 'root')
        end
    end

    def process_cmd(command, connection, chanstr = nil)
        puts "MockFAHC: #{Time.now}: processing command on #{chanstr}: #{command}" if chanstr
        cmdary = command.split
        case cmdary[0]
        when 'ping'
            connection.puts '0.0.0 Uh'
        when 'slot-info'
            connection.puts "\nPyON 1 slots\n[\n  {\n    \"id\": \"00\",\n    \"status\": \"Pretending\"\n  }\n]\n---\n> "
        when 'queue-info'
            connection.puts "\nPyON 1 units\n[\n  {\n    \"id\": \"00\",\n    \"percentdone\": \"#{@percent = @percent + 1}\",\n    \"eta\": \"#{Time.now + 60}\"\n  }\n]\n---\n> "
        when 'updates'
            case cmdary[1]
            when 'clear'
                @updates = Array.new
            when 'add'
                update_chan = cmdary[2].to_i
                update_interval = cmdary[3].to_i
                update_cmd = cmdary[4..].join(' ')[1..]
                puts "MockFAHC: #{Time.now}: Update chan #{update_chan} interval #{update_interval} command \"#{update_cmd}\""
                if update_chan > 0 && update_chan < 12 && update_interval > 0 
                    @updates[update_chan] = { :interval => update_interval, :cmd => update_cmd }
                    Thread.start(update_interval, update_cmd, update_chan, connection) do |ui, ucmd, uch, conn|
                        loop do
                            process_cmd(ucmd, conn, "update channel #{uch}")
                            sleep(ui)
                        end
                    end
                end
            end
        else
            connection.puts "#{cmdary[0]}: command not implemented"
        end        
    end
end

MockFahc.new(36330, 'localhost')
