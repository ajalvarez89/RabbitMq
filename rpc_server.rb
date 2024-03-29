#!/usr/bin/env ruby
require 'bunny'
require 'byebug'

class FibonacciServer
  def initialize
    @connection = Bunny.new
    @connection.start
    @channel = @connection.create_channel
    exchange = channel.fanout("test.fibonacci")
  end

  def start(queue_name)
    @queue = channel.queue(queue_name)
    @exchange = channel.default_exchange
    subscribe_to_queue
  end

  def stop
    channel.close
    connection.close
  end

  def loop_forever
    # This loop only exists to keep the main thread
    # alive. Many real world apps won't need this.
    loop { sleep 5 }
  end

  private

  attr_reader :channel, :exchange, :queue, :connection

  def subscribe_to_queue
    
    queue.subscribe do |_delivery_info, properties, payload|
      result = fibonacci(payload.to_i)
      
      exchange.publish(
        result.to_s,
        routing_key: properties.reply_to,
        correlation_id: properties.correlation_id
      )
    end
  end
 #how does fibonacci work?
  def fibonacci(value)
    return value if value.zero? || value == 1

    fibonacci(value - 1) + fibonacci(value - 2)
  end
end

begin
  byebug
  server = FibonacciServer.new

  puts ' [x] Awaiting RPC requests'
  server.start('rpc_queue')
  server.loop_forever
  server.ack!
rescue Interrupt => _
  server.stop
end