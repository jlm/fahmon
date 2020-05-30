#
require 'json'
require './sock_client.rb'

class PyONClient < Client

  def parse_response(resp)
    puts "parse_response: processing response: #{resp}" if $DEBUG
    lumps = []
    pktsplit = resp.split(/(PyON 1 \w+)|(---)/)
    pktsplit.slice_before(/^PyON/).each do |pkt|
      #puts "Here comes a packet: #{pkt}"
      trimmed = pkt.take_while { |x| !x.match(/---/) }.drop_while { |y| !y.match(/^PyON/) }
      #p trimmed
      i = trimmed.index { |el| el.match(/PyON 1 (\w+)/) }
      name = $1
      #puts "index is #{i.inspect}"
      if i
        pyon_content = trimmed[i+1]
        json_content = pyon_content.gsub("False", "false").gsub("True", "true").gsub("None", "nil")
        #p [ name, JSON.parse(json_content) ]
        lumps << [ name, JSON.parse(json_content) ]
      end
    end
    puts "parse_response prints:" if $DEBUG
    p lumps if $DEBUG
    @pyon_answer_processor.call(lumps) if @pyon_answer_processor
  end

  def initialize(sock, pyon_answer_processor)
    @pyon_answer_processor = pyon_answer_processor
    super(sock, Proc.new  { |rsp| parse_response(rsp) })
  end

end
