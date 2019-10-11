module Helpers
  def fixture_file(path)
    File.open("#{RSPEC_ROOT}/fixtures/#{path}", 'r')
  end
end