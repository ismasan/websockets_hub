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