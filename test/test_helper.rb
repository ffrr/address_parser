$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'address_parser'

require 'minitest/autorun'

require 'webmock/minitest'

WebMock.disable_net_connect!(allow_localhost: true)
