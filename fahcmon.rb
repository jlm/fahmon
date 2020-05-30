#
require 'socket'
require './pyon_client.rb'

def action_response(lumps)
  puts "action_response says:" if $DEBUG
  lumps.each do |lump|
    case lump[0]
    when "slots"
      lump[1].each do |slot|
        puts "Slot #{slot["id"]}: status #{slot["status"]}"
      end
    when "units"
      lump[1].each do |unit|
        puts "Current queue #{unit["id"]}: #{unit["percentdone"]} done, ETA #{unit["eta"]}"
      end
    else
      puts "Unparsed message received: #{lump[0]}: #{lump[1]}"
    end
  end
end

fahc_host = ARGV[0] || "localhost"
socket = TCPSocket.open(fahc_host, 36330)

Thread.new do
  socket.puts "updates clear"
  socket.puts "updates add 5 10 $slot-info"
  socket.puts "updates add 6 15 $queue-info"
  unless true
    loop do
      socket.puts "queue-info"
      sleep 60
    end
  end
end

PyONClient.new(socket, Proc.new { |lumps| action_response(lumps) })
