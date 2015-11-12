require "faraday"
require "json"

API_URL = "http://minly.herokuapp.com/"
API_SHOW_ACTION = API_URL + "api/v1/requests/show/"

module Minly
  class Url
    attr_accessor :token
    attr_reader :status, :response, :connection

    def initialize(token = nil)
      @connection = Faraday.new(:url => API_URL)
      @token = token
    end

    def expand_minly(url)
      make_get_request(API_SHOW_ACTION + "expand/" + url)
    end

    def popular_minlys
      make_get_request(API_SHOW_ACTION + "popular/")
    end

    def recent_minlys
      make_get_request(API_SHOW_ACTION + "recent/")
    end

    def create_minly(url, vanity_string = '')
      return false if (vanity_string.nil? || (!vanity_string.empty? && has_no_token_error) )
      @token ||= 0
      params = {
        "url[shortened]" => vanity_string,
        "url[original]" => url,
        "user_token" => token
      }
      process_response connection.post("/urls.json", params)
      # user_token=vBIPTJtcHX7cORPGjFXOLvIzKU9hmHX05FST_t-sY6s
    end

    def change_minly_target(url, target)
      return false if has_no_token_error
      params = {
        "url[original]" => target,
        user_token: token
      }
      process_response connection.put("/urls/#{url}.json", params)
    end

    def change_minly_status(url, data)
      return false if has_no_token_error
      params = {
        "url[active]" => data,
        user_token: token
      }
      process_response connection.put("/urls/#{url}.json", params)
    end

    def destroy_minly(url)
      return false if has_no_token_error
      params = {
        user_token: token
      }
      process_response connection.delete("/urls/#{url}.json", params)
    end

    def update_minly(url, origin, active)
      return false if (has_no_token_error || !origin || origin.empty? || active.nil?)
      params = {
        "url[active]" => active,
        "url[orignal]" => origin,
        user_token: token
      }
      process_response connection.put("/urls/#{url}.json", params)
    end

    def make_get_request(request)
      process_response(connection.get(request))
    end

    def process_response(response)
      response = JSON.parse(response.body)
      @status = parse_status(response)
      @response = response["payload"]
    end

    def has_no_token_error
      if !token || token == 0
        @status = {type: "error", info: "Request requires a valid user token."}
        return true
      end
      false
    end

    def parse_status(response)
      {type: response["status"], info: response["status_info"]}
    end
  end
end
