class LookupController < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
  end

  def results
    begin
      @cached_response = weatherkit.cache_exists_for?(params[:address])
      @forecast = weatherkit.forecast(params[:address])
      @current = @forecast[:currentWeather].with_indifferent_access
      @nxt_days = @forecast[:forecastDaily]["days"].map(&:with_indifferent_access)

    rescue ArgumentError => e
      # this means it didn't work; temporary error... redirect to home
      flash.alert = "There was an API error, please try again."
      redirect_to action: :index and return
    end
  end

  private

  def weatherkit
    @weatherkit ||= WeatherKit.new
  end
end
