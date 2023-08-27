# require "erb"

require_relative "advice"
require_relative "erb_rack_framework"

class App < ERBRackFramework
  def call(env)
    headers = { "Content-Type" => "text/html" }

    case env["REQUEST_PATH"]
    when "/"
      status_code = 200
      body = erb("index")
    when "/advice"
      status_code = 200
      body = erb("advice", message: Advice.new.generate)
    else
      error_message = erb("not_found")

      status_code = 404
      headers["Content-Length"] = error_message.size.to_s
      body = error_message
    end

    response(status_code, headers, body)
  end
end
