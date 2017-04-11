require 'dotenv'
require_relative 'resource_accessor'
Dotenv.load

resource_accessor = ResourceAccessor.new

resource_accessor.handle_windspeed_error_value
