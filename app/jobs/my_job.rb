class MyJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Performing job with args: #{args.inspect}"
  end
end
