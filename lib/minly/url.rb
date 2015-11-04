require "faraday"
require "json"

API_URL = "http://localhost:3000/"
API_SHOW_ACTION = API_URL + "api/v1/requests/show/"

module Minly
  class Url
    attr_accessor :token
    attr_reader :status, :response

    def initialize(token = nil)
      @connection = Faraday.new(:url => API_URL)
      @token = token
    end

    def expand(url)
      make_get_request(API_SHOW_ACTION + "expand/" + url)
    end

    def popular_urls
      make_get_request(API_SHOW_ACTION + "popular/")
    end

    def recent_urls
      make_get_request(API_SHOW_ACTION + "recent/")
    end

    def shorten_url(url, vanity_string = '')
      return false if has_no_token_error && !vanity_string.empty?
      @token ||= 0
      params = {
        "url[shortened]" => vanity_string,
        "url[original]" => url,
        "user_token" => token
      }
      process_resonse @connection.post("/urls.json", params)
      # user_token=vBIPTJtcHX7cORPGjFXOLvIzKU9hmHX05FST_t-sY6s
    end

    def change_url_target(url, target)
      return false if has_no_token_error
      params = {
        "url[original]" => target,
        user_token: token
      }
      process_resonse @connection.put("/urls/#{url}.json", params)
    end

    def change_url_status(url, data)
      return false if has_no_token_error
      params = {
        "url[active]" => data,
        user_token: token
      }
      process_resonse @connection.put("/urls/#{url}.json", params)
    end

    def destroy_url(url)
      return false if has_no_token_error
      params = {
        user_token: token
      }
      process_resonse @connection.delete("/urls/#{url}", params)
    end

    def update_url(url, origin="", active="")
      return false if has_no_token_error
    end

    def make_get_request(request)
      process_resonse(@connection.get(request))
    end

    def process_resonse(response)
      response = JSON.parse(response.body)
      @status = parse_status(response)
      @response = response["payload"]
    end

    def has_no_token_error
      if !token || token == 0
        @status = {type: "Error", info: "Request requires a valid user token."}
        return true
      end
      false
    end

    def parse_status(response)
      {type: response["status"], info: response["status_info"]}
    end
  end
end
