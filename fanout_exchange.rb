require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
exchange = channel.fanout("surf.swells")

channel.queue("grecia", :auto_delete => false).bind(exchange).subscribe do |info, metadata,payload |
  p "#{payload} => grecia"
end

channel.queue("lady", :auto_delete => false).bind(exchange).subscribe do |info, metadata,payload |
  p "#{payload} => lady"
end

channel.queue("alvaro", :auto_delete => false).bind(exchange).subscribe do |info, metadata,payload |
  p "#{payload} => alvaro"
end

exchange.publish("lower trestles, perfect head high")
  .publish("ocean beach, double overheads")

sleep 1.0

connection.close