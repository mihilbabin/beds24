RSpec.describe Beds24::XMLRequest do
  subject { described_class.new auth, opts }
  let(:auth) { { username: 'username', password: 'password' } }

  describe 'without opts' do
    let(:opts) { {} }
    let(:xml) do
      <<~XML.chomp
      <request>
        <auth>
          <username>#{auth[:username]}</username>
          <password>#{auth[:password]}</password>
        </auth>
      </request>
      XML
    end

    it 'renders valid XML' do
      expect{subject.to_xml}.to_not raise_error
    end

    it 'renders request and auth' do
      expect(subject.to_xml).to eq xml
    end
  end

  describe 'with opts' do
    let(:opts) { { data: 'data', property: 'property'} }
    let(:xml) do
      <<~XML.chomp
      <request>
        <auth>
          <username>#{auth[:username]}</username>
          <password>#{auth[:password]}</password>
        </auth>
        <data>#{opts[:data]}</data>
        <property>#{opts[:property]}</property>
      </request>
      XML
    end

    it 'renders valid XML' do
      expect{subject.to_xml}.to_not raise_error
    end

    it 'renders opts' do
      expect(subject.to_xml).to eq xml
    end
  end
end