require "bundler/setup"
# require "rack"

class MyApp
  def call(env)
    code = 200
    headers = { "Content-Type" => "text/html" }
    body = ["<h4>`env` values:</h4>"] + [env.map { |k, v| "#{k} : #{v}" }.join("<br>")]
    [code, headers, body]
  end
end

class FriendlyGreeting
  def initialize(app)
    @app = app
  end

  def call(env)
    code, headers, body = @app.call(env)
    [code, headers, body.prepend("<h3>A warm welcome to you!</h3>")]
  end
end

class Wave
  def initialize(app)
    @app = app
  end

  def call(env)
    code, headers, body = @app.call(env)
    [code, headers, body.prepend("<h2>Wave from afar!</h2>")]
  end
end

# Rack::Handler::WEBrick.run FriendlyGreeting.new(MyApp.new)
