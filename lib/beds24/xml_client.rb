module Beds24
  class XMLClient
    include HTTParty
    base_uri Constants::XML_API_ENDPOINT
    headers 'Content-Type' => 'text/xml'

    attr_accessor :username, :password

    def initialize(username, password)
      @username = username
      @password = password
    end

    def get_properties(opts = {})
      response = self.class.post('/getProperties', body: xmlize(opts.slice(:propid)))
      parse! response
    rescue APIError => e
      e.response
    end

    def get_bookings(opts = {})
      valid_opts = opts.slice(*Constants::VALID_XML_BOOKING_OPTS)
      response = self.class.post('/getBookings', body: xmlize(valid_opts))
      parse! response
    rescue APIError => e
      e.response
    end

    def modify_booking(id, attrs = {})
      response = self.class.post('/putBookings', body: modify_payload(id, attrs))
      parse! response
    rescue APIError => e
      e.response
    end

    private

    def parse!(response)
      hash = Hash.from_xml(response.body)
      raise APIError.new(
        "API Error: #{hash['code']} #{hash['error']}",
        hash
      ) if hash.key?('error')
      hash
    end

    def auth
      { username: @username, password: @password }
    end

    def xmlize(opts = {})
      XMLRequest.new(auth, opts).to_xml
    end

    def modify_payload(id, attrs = {})
      payload = Nokogiri::XML(xmlize())
      Nokogiri::XML::Builder.with(payload.at('request')) do |xml|
        xml.bookings do
          xml.booking(id: id, action: 'modify') do
            attrs.each do |prop, value|
              xml.public_send prop, value
            end
          end
        end
      end.doc.root.to_xml
    end
  end
end