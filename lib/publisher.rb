class Publisher
  
  def initialize(dispatcher)
    @dispatcher = dispatcher
  end
  
  def setup(*args)
    
  end
  
  def run
    
  end
  
  def publish(message)
    @dispatcher.publish self.class.name, message
  end

end