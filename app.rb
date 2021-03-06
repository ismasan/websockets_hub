$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'

require 'rubygems'
require "bundler/setup"

require 'yaml'
require 'eventmachine'
require 'active_support/inflector'

require 'dispatcher'
require 'publisher'

EM.run {
  
  
  dispatcher = Dispatcher.new
  
  # Configure and register publishers
  config = YAML.load_file('./config/config.yml')
  
  config[:publishers].each do |publisher_name, settings|    
    dispatcher.register publisher_name, settings
  end
  
  
  dispatcher.on_message do |publisher_name, message|
    puts "#{publisher_name}: #{message}"
    # Persist
    
    # Websockets push
  end
  
  dispatcher.run
}

