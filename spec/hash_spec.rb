RSpec.describe Hash do
  describe '#from_xml' do
    let(:xml_file) { fixture_file('bookings.xml') }
    let(:xml_string) { xml_file.read }
    let(:parsed) { Hash.from_xml(xml_file) }

    let(:id) { '13300894' }
    let(:root) { 'bookings' }
    let(:attribute) { 'datefrom' }

    it 'responds to new method' do
      expect(Hash).to respond_to(:from_xml)
    end

    it 'parses valid XML string without errors' do
      expect { Hash.from_xml(xml_string) }.to_not raise_error
    end

    it 'parses valid XML file without errors' do
      expect { Hash.from_xml(xml_file) }.to_not raise_error
    end

    it 'includes XML tags' do
      expect(parsed[root]).to_not be_nil
    end

    it 'returns nested tags' do
      expect(parsed.dig(root, id)).to_not be_nil
    end

    it 'preserves attributes' do
      expect(parsed.dig(root, attribute)).to_not be_nil
    end
  end
end