$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'

require 'rubygems'
require 'yaml'
require 'eventmachine'
require 'active_support/inflector'

require 'publisher'
require 'twitter_stream'

class Dispatcher
  
  def initialize
    @publishers = {}
    @callbacks = []
  end
  
  def register(published_klass, settings)
    require published_klass.to_s
    @publishers[ActiveSupport::Inflector.classify(published_klass.to_s)] = settings
  end
  
  def run
    @publishers.each do |klass, settings|
      pub = ActiveSupport::Inflector.constantize(klass).new(self)
      pub.setup settings
      pub.run
    end
  end
  
  def on_message(&callback)
    @callbacks << callback
  end
  
  def publish(publisher_name, message)
    @callbacks.each do |callback|
      callback.call publisher_name, message
    end
  end
  
end

EM.run {
  
  config = YAML.load_file('./config/config.yml')
  
  dispatcher = Dispatcher.new
  
  config[:publishers].each do |publisher_name, settings|    
    dispatcher.register publisher_name, settings
  end
  
  
  dispatcher.on_message do |publisher_name, message|
    
    puts "#{publisher_name}: #{message}"
  end
  
  dispatcher.run
}

