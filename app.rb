$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'

require 'rubygems'
require 'yaml'
require 'eventmachine'
require 'active_support/inflector'

require 'dispatcher'
require 'publisher'

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

