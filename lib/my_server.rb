# Your starting point for daemon specific classes. This directory is
# already included in your load path, so no need to specify it.

class MyServer < EventMachine::Connection
  include EventMachine::HttpServer
  def process_http_request
    resp = EventMachine::DelegatedHttpResponse.new( self )
    # Block which fulfills the request
    operation = proc do
      request = @http_request_uri.sub("/", "")
      request_type = @http_request_method
      resp.status  = 200
      if request_type == "GET"
       case request
          when "get-request"
            resp.content = {"status" => "Get request obtained"}.to_json
            DaemonKit.logger.info "Got query_string #{@http_query_string}"
       	 end
      elsif request_type == "POST"
       case request
          when "post-request"
            resp.content = {"status" => "Post request obtained"}.to_json
            DaemonKit.logger.info "Got data #{@http_post_content}"
          end
      else
        resp.content = {"status" => "Error. Got odd request type #{request_type}"}.to_json
            DaemonKit.logger.info "Got Incorrect data in request "
      end
    end

    # Callback block to execute once the request is fulfilled
    callback = proc do |res|
    	resp.send_response
    end
 
    # Let the thread pool (20 Ruby threads) handle request
    EM.defer(operation, callback)    
  end
end
