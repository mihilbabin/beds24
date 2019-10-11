module Beds24
  class XMLRequest
    def initialize(auth, opts = {})
      @auth = auth
      @opts = opts
    end

    def to_xml
      data = builder.new do |xml|
        xml.request do
          xml.auth do
            xml.username @auth[:username]
            xml.password @auth[:password]
          end
          @opts.each do |prop, value|
            xml.public_send prop, value
          end
        end
      end
      data.doc.root.to_xml
    end

    private

    def builder
      Nokogiri::XML::Builder
    end
  end
end