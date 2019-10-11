RSpec.describe Beds24::XMLClient do
  subject { described_class.new username, password }
  let(:username) { 'username' }
  let(:password) { 'dummypassword' }

  describe '#initialize' do
    it 'accepts auth data' do
      expect{ subject }.not_to raise_error
    end
  end

  describe 'accessors' do
    describe 'password' do
      let(:new_password) { 'newdummypassword' }
      it 'allows to access password' do
        expect(subject.password).to eq password
      end

      it 'allows to set password' do
        client = subject
        client.password = new_password
        expect(client.password).to eq new_password
      end
    end

    describe 'username' do
      let(:new_name) { 'newname' }
      it 'allows to access username' do
        expect(subject.username).to eq username
      end

      it 'allows to set username' do
        client = subject
        client.username = new_name
        expect(client.username).to eq new_name
      end
    end
  end

  context 'endpoints' do
    shared_examples 'unauthorized' do
      it 'returns unauthorized error' do
        expect(subject).to eq({ 'error' => { 'code' => '1004', 'text' => 'Unauthorized'}})
      end
    end

    describe '#get_properties' do
      subject { described_class.new(username, password).get_properties(opts) }
      let(:opts) { {} }

      context 'wrong credentials' do
        before(:each) do
          stub_request(
            :post,
            "#{Beds24::Constants::XML_API_ENDPOINT}/getProperties"
          ).with(
            body: Beds24::XMLRequest.new({ username: username, password: password }).to_xml
          ).to_return(body: <<-XML
          <error code="1004">Unauthorized</error>
          XML
          )
        end

        it_behaves_like 'unauthorized'
      end

      context 'correct credentials' do
        before(:each) do
          stub_request(
            :post,
            "#{Beds24::Constants::XML_API_ENDPOINT}/getProperties"
          ).with(
            body: Beds24::XMLRequest.new({ username: username, password: password }).to_xml
          ).to_return(body: fixture_file('properties.xml').read)
        end

        it 'returns parsed properties' do
          expect(subject['properties']).to_not be_empty
        end
      end
    end

    describe '#get_bookings' do
      subject { described_class.new(username, password).get_bookings(opts) }
      let(:opts) { {} }

      context 'wrong credentials' do
        before(:each) do
          stub_request(
            :post,
            "#{Beds24::Constants::XML_API_ENDPOINT}/getBookings"
          ).with(
            body: Beds24::XMLRequest.new({ username: username, password: password }).to_xml
          ).to_return(body: <<-XML
          <error code="1004">Unauthorized</error>
          XML
          )
        end

        it_behaves_like 'unauthorized'
      end

      context 'correct credentials' do
        before(:each) do
          stub_request(
            :post,
            "#{Beds24::Constants::XML_API_ENDPOINT}/getBookings"
          ).with(
            body: Beds24::XMLRequest.new({ username: username, password: password }).to_xml
          ).to_return(body: fixture_file('bookings.xml').read)
        end

        it 'returns parsed bookings' do
          expect(subject['bookings']).to_not be_empty
        end
      end
    end

    describe '#modify_booking' do
      let(:id) { 1 }
      let(:opts) { { guestFirstName: name } }
      let(:name) { 'Jane' }
      subject { described_class.new(username, password).modify_booking(id, opts) }

      context 'wrong credentials' do
        before(:each) do
          stub_request(
            :post,
            "#{Beds24::Constants::XML_API_ENDPOINT}/putBookings"
          ).with(
            body: <<~XML.strip
              <request>
                <auth>
                  <username>#{username}</username>
                  <password>#{password}</password>
                </auth>
              <bookings><booking id="#{id}" action="modify"><guestFirstName>#{name}</guestFirstName></booking></bookings></request>
            XML
          ).to_return(body: <<-XML
          <error code="1004">Unauthorized</error>
          XML
          )
        end

        it_behaves_like 'unauthorized'
      end

      context 'correct credentials' do
        before(:each) do
          stub_request(
            :post,
            "#{Beds24::Constants::XML_API_ENDPOINT}/putBookings"
          ).with(
            body: <<~XML.strip
            <request>
              <auth>
                <username>#{username}</username>
                <password>#{password}</password>
              </auth>
            <bookings><booking id="#{id}" action="modify"><guestFirstName>#{name}</guestFirstName></booking></bookings></request>
          XML
          ).to_return(body: <<~XML
            <?xml version="1.0" encoding="UTF-8"?>
            <bookings>
              <booking id="#{id}" action="modify">
                <guestFirstName>#{name}</guestFirstName>
              </booking>
            </bookings>
          XML
          )
        end

        it 'returns edited fields' do
          pp subject
          expect(subject.dig("bookings", id.to_s, "guestFirstName")).to eq name
        end
      end
    end
  end
end