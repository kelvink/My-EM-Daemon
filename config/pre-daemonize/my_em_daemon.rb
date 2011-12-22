require 'eventmachine'
require 'evma_httpserver'
require 'json'

CONFIG = DaemonKit::Config.load("config.yml")

require File.join(DaemonKit.root, 'lib', "my_server.rb")
