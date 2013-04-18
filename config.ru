require 'rubygems'
require 'bundler'
require 'uri'
require 'net/http'

Bundler.require

helpers do

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Not authorized\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [ENV['DASHBOARD_USERNAME'], ENV['DASHBOARD_PASSWORD']]
  end

  def send_message
    direct_print_url = URI.parse("http://remote.bergcloud.com/playground/direct_print/#{ENV['LP_DIRECT_PRINT_CODE']}")
    message  = erb :stationery, :layout => nil
    response = Net::HTTP.post_form(direct_print_url, {"html" => message })
    p response.code
  end

end

require './app.rb'
run Sinatra::Application
