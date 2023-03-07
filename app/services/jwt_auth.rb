# frozen_string_literal: true

module JwtAuth

  PREF_ALGO = "ES256".freeze
  TOKEN_API_ENDPOINT = "/v1/token".freeze

  def self.included(base)
    unless base.const_defined?(:API_BASE)
      base.const_set :API_BASE, "https://api.example.com"
    end
  end

  def jwt_encode
    JWT.encode(jwt_payload, ec_private_key, PREF_ALGO, jwt_headers)
  end

  def jwt_decode(token)
    JWT.decode(token, ec_private_key, true, { algorithm: PREF_ALGO })
  end

  private

  def conn(bearer_proc)
    Faraday.new(url: self.class.const_get(:API_BASE)) do |conn|
      conn.request :json
      conn.request :authorization, 'Bearer', -> { bearer_proc.call }
      conn.response :json
    end
  end

  def ec_private_key
    @ec_private_key ||= OpenSSL::PKey.read(open(Rails.root.join("config/AuthKey_#{ENV.fetch("APPLE_PRIVATE_KEY_ID")}.p8")).read)
  end

end
