# Your starting point for daemon specific classes. This directory is
# already included in your load path, so no need to specify it.

EM.run do
  EventMachine.epoll
  EventMachine::start_server("0.0.0.0", CONFIG.port, MyServer)
  DaemonKit.logger.info "Listening on port #{CONFIG.port}"
end
