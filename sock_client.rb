#
require 'socket'

class Client
  def initialize(socket, answer_processor)
    @socket = socket
    @answer_processor = answer_processor
    @request_object = send_request
    @response_object = listen_response

    @request_object.join    # will send the request
    @response_object.join   # will receive the responses from the server
  end

  def send_request
    begin
      Thread.new do
        @socket.puts "slot-info"
      end
    rescue IOError => e
      puts e.message
      @socket.close
    end
  end

  def listen_response
    begin
      Thread.new do
        loop do
          begin
            #response = @socket.gets.chomp
            response = @socket.read_nonblock(4096)
          rescue IO::WaitReadable
            IO.select([@socket])
            retry
          rescue EOFError => ee
            puts "socket: " + ee.message
            @socket.close
            exit(1)
          end
            #puts "#{response}"
          @answer_processor.call(response) if @answer_processor
        end
      end
    rescue IOError => e
      puts e.message
      @socket.close
    end
  end
end
