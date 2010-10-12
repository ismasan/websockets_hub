require 'rubygems'
require 'em-http'
require 'json'

class TwitterStream < Publisher
  URL = 'http://stream.twitter.com/1/statuses/filter.json'
  
  def setup(settings = {})
    @username   = settings[:user_name]
    @password   = settings[:password]
    @term       = settings[:term]
    @buffer     = ""
  end
  
  def run
    listen
  end

  private

  def listen
    http = EventMachine::HttpRequest.new(URL).post({
      :head => { 'Authorization' => [ @username, @password ] },
      :query => { "track" => @term }
    })

    http.stream do |chunk|
      @buffer += chunk
      process_buffer
    end
  end

  def process_buffer
    while line = @buffer.slice!(/.+\r\n/)
      tweet = JSON.parse(line)
      publish tweet
    end
  end
end