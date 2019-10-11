module Beds24
  module Constants
    API_ROOT = 'https://beds24.com/api'.freeze
    JSON_API_ENDPOINT = "#{API_ROOT}/json".freeze
    XML_API_ENDPOINT = "#{API_ROOT}/xml".freeze

    PARSE_ERROR_MSG = 'Got encoding different from JSON. Please check passed options'.freeze

    DEFAULT_PROPERTY_OPTIONS = {
      includeRooms: false,
      includeRoomUnits: false,
      includeAccountAccess: false
    }.freeze

    DEFAULT_BOOKING_OPTIONS = {
      includeInvoice: false,
      includeInfoItems: false
    }.freeze

    VALID_XML_BOOKING_OPTS = %i[
      modified
      datefrom
      dateto
      propid
      roomid
      masterid
      bookid
    ].freeze
  end
end