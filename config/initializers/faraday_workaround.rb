module Faraday
  module NestedParamsEncoder
    def self.escape(arg)
      arg
    end
  end
  module FlatParamsEncoder
    def self.escape(arg)
      arg
    end
  end
end

Faraday.default_connection_options = { headers: { user_agent: 'Apple WeatherKit Client abc123' } }
