require 'open-uri'
require 'json'
BLOCKHEIGHT=65

Shoes.app(width: 500, height: 4*BLOCKHEIGHT+25) do
  def getscore
    begin
      scores = JSON.parse(URI.open('https://stats.foldingathome.org/api/donors?name=John_Messenger&search_type=exact').read())
      results = scores['results'][0]
      @score.text = results['credit']
      @rank.text = results['rank']
    rescue => e
      puts e.message
      @score.text = ''
      @rank.text = ''
    end
  end

  flow do
    stack width: 135, margin: 10 do
      stack height: BLOCKHEIGHT do
        para("Your score is", top: 18, right: 0)
      end
      stack height: BLOCKHEIGHT do
        para("Your rank is", top: 18)
      end
      stack height: BLOCKHEIGHT do
        para("Status", top: 18)
      end
      stack height: BLOCKHEIGHT do
        para("Progress", top: 18)
      end
    end

    stack width: 250 do
      stack height: BLOCKHEIGHT do
        @score = title(strong "Unknown")
      end
      stack height: BLOCKHEIGHT do
        @rank = title(strong "Unknown")
        getscore
        every(300) { getscore }
      end
      stack height: BLOCKHEIGHT do
        $status = title(strong "Unknown")
      end
      stack height: BLOCKHEIGHT do
        $progress = progress width: 300
      end

    end
  end

end

#
require 'socket'
require './pyon_client.rb'

def action_response(lumps)
  puts "action_response says:" if $debug
  lumps.each do |lump|
    case lump[0]
    when "slots"
      lump[1].each do |slot|
        puts "Slot #{slot["id"]}: status #{slot["status"]}"
      end
      $status.text = lump[1].first["status"] if $status
    when "units"
      lump[1].each do |unit|
        puts "Current queue #{unit["id"]}: #{unit["percentdone"]} done, ETA #{unit["eta"]}"
      end
      $progress.fraction = lump[1].first["percentdone"].chop.to_f / 100.0
    else
      puts "Unparsed message received: #{lump[0]}: #{lump[1]}"
    end
  end
end

socket = TCPSocket.open("localhost", 36330)

Thread.new do
  socket.puts "updates clear"
  socket.puts "updates add 0 10 $slot-info"
  socket.puts "updates add 1 15 $queue-info"
  unless true
    loop do
      socket.puts "queue-info"
      sleep 60
    end
  end
end

Thread.new do
  sleep(1) until $progress
  PyONClient.new(socket, Proc.new { |lumps| action_response(lumps) })
end

