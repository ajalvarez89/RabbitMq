require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel

queue1 = channel.queue("postoffice.grecia", :auto_delete => true)
queue2 = channel.queue("postoffice.lady", :auto_delete => true)
queue3 = channel.queue("postoffice.alvaro", :auto_delete => true)

exchange = channel.default_exchange

queue1.subscribe do | info, metadata, payload |
  puts "grecia's box received, #{payload}"
end

queue2.subscribe do | info, metadata, payload |
  puts "lady's box received, #{payload}"
end

queue3.subscribe do | info, metadata, payload |
  puts "alvaro's box received, #{payload}"
end

exchange.publish("i like big waves", :routing_key => "postoffice.grecia")
  .publish("i like making apps", :routing_key => "postoffice.lady")
  .publish("i like winning big titles", :routing_key => "postoffice.alvaro")

sleep 1.0

connection.close

