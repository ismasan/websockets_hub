## Websockets hub (in progress)

Subscribe "publishers" like Twitter stream, IRC, Github commits, etc. and pipe them to websocket consumers.

    git clone [REPO URL HERE]
    cd websockets_hub
    bundle install
    mv config/config.yml.example config/config.yml
    # Edit config/config.yml
    ruby app.rb