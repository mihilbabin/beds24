require 'httparty'
require 'oj'

require 'beds24/constants'
require 'beds24/json_client'
require 'beds24/version'
require 'beds24/xml_client'
require 'beds24/xml_request'

require 'ext/hash'

module Beds24
  class Error < StandardError; end

  class APIError < StandardError
    attr_accessor :response

    def initialize(msg, response)
      super(msg)
      @response = response
    end
  end
end
