#!/usr/bin/env ruby

require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel

queue = channel.queue('hello')

channel.default_exchange.publish('Hello World Alvaro!', routing_key: queue.name)
puts " [x] Sent 'Hello World!' for the quote: #{queue.name}"

connection.close