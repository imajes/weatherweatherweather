# frozen_string_literal: true

class MapKit

  API_BASE = "https://maps-api.apple.com".freeze
  TOKEN_API_ENDPOINT = "/v1/token".freeze
  GEOCODE_API_ENDPOINT = "/v1/geocode".freeze

  extend Memoist
  include JwtAuth

  def geocode(addr)
    request_uri = "#{GEOCODE_API_ENDPOINT}?q=#{CGI.escape(addr)}"
    res = conn(-> { access_token }).get(request_uri)

    if res.status > 200
      # report back an error state
    else
      geocode_res = res.body["results"].first
      coords = geocode_res&.fetch("coordinate", "missing-coordinates")

      if coords.nil?
        raise ArgumentError
      end

      {
        lat: coords["latitude"],
        lng: coords["longitude"],
        country: geocode_res["countryCode"]
      }
    end
  end

  def access_token
    conn(-> { jwt_encode }).get(TOKEN_API_ENDPOINT).body.fetch("accessToken", "maps-access-token-failed")
  end
  memoize :access_token

  def jwt_headers
    {
      alg: PREF_ALGO,
      kid: ENV.fetch("APPLE_PRIVATE_KEY_ID", ""), # key id
      typ: "JWT"
    }
  end

  def jwt_payload
    {
      iss: ENV.fetch("APPLE_TEAM_ISSUER_ID", ""), # team issuer id
      iat: Time.zone.now.to_i, # issued at registered claim key timestamp epoch
      exp: (Time.zone.now + 6.hours).to_i, # "" expiry timestamp epoch
    }
  end

end

