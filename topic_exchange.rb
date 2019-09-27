require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel

exchange = channel.topic("news", :auto_delete => false)

channel.queue("test_rabbit", :exclusive => true).bind(exchange, :routing_key => "world.politics.#").
  subscribe do |info, metadata, payload|
  puts "ON THE TOPICS POLITICS, #{payload}, routing key => #{info.routing_key}"
end

channel.queue("", :exclusive => true).bind(exchange, :routing_key => "#.internetgovernance.cybercrime").
  subscribe do |info, metadata, payload|
  puts "ON THE TOPIC OF INTERNET GOVERNANCE, #{payload}, routing key => #{info.routing_key}"
end

channel.queue("", :exclusive => true).bind(exchange, :routing_key => "world.politics.intergovernance.*").
  subscribe do |info, metadata, payload|
  puts "ON THE TOPICS OF THE WORLD, POLITICS, AND INTERNET GOVERNANCE #{payload}, routing key => #{info.routing_key}"
end

#we would expect to see this message thrice
exchange.publish("Havoc ensues", :routing_key => "world.politics.internetgovernance.cybercrime")

#we would expect to see this one times
exchange.publish("People come together", :routing_key => "world.politics.someother.nonrelatedtopic")

#we would expect to see this one times
exchange.publish("People ponder the relevance of copyright", :routing_key => "global.ambassadorship.internetgovernance.cybercrime")

#we would expect to see this message thrice
exchange.publish("Confusion is lifted", :routing_key => "world.politics.internetgovernance.netneutrality")

sleep 1.0

connection.close


