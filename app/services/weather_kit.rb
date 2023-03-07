# frozen_string_literal: true

class WeatherKit

  API_BASE = "https://weatherkit.apple.com/".freeze
  AVAILABLITY_API_ENDPOINT = "/api/v1/availability".freeze
  FORECAST_API_ENDPOINT = "/api/v1/weather/en".freeze

  # This comes from the availability endpoint, but the api is so slow as it is
  # it's not worth making this dynamic -- so lets assume all areas support all
  # datasets.
  # DATASETS = "currentWeather,forecastDaily,forecastHourly,trendComparison,forecastNextHour,weatherAlerts".freeze
  DATASETS = "currentWeather,forecastDaily".freeze

  include JwtAuth

  def cache_exists_for?(loc)
    Rails.cache.exist?("forecast_for_#{loc}")
  end

  def forecast(loc)
    Rails.cache.fetch("forecast_for_#{loc}", expires_in: 30.minutes) do
      execute_forecast(loc)
    end
  end

  def execute_forecast(loc)
    coords = MapKit.new.geocode(loc)

    request_uri = "#{FORECAST_API_ENDPOINT}/#{coords[:lat]}/#{coords[:lng]}?countryCode=#{coords[:country]}&timezone=CST&dataSets=#{DATASETS}"

    res = conn(-> { jwt_encode }).get(request_uri)

    if res.status > 200
      raise ArgumentError
    else
      res.body.with_indifferent_access
    end
  end

  def jwt_headers
    {
      alg: PREF_ALGO,
      kid: ENV.fetch("APPLE_PRIVATE_KEY_ID", ""), # key id
      id: "#{ENV.fetch("APPLE_TEAM_ISSUER_ID", "")}.#{ENV.fetch("APPLE_SERVICE_ID", "")}"
    }
  end

  def jwt_payload
    {
      iss: ENV.fetch("APPLE_TEAM_ISSUER_ID", ""), # team issuer id
      iat: (Time.zone.now - 10.seconds).to_i, # issued at registered claim key timestamp epoch
      exp: (Time.zone.now + 1.week).to_i, # "" expiry timestamp epoch
      sub: ENV.fetch("APPLE_SERVICE_ID", ""),
    }
  end
end
