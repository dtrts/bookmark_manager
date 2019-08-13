require_relative '../lib/bookmarks.rb'
describe Bookmarks do
  it 'shows list of bookmarks' do
    expect(described_class.all).to include('www.google.com')
    expect(described_class.all).to include('www.facebook.com')
  end

  it 'adds a bookmark' do
    described_class.add('https://github.com')
    expect(described_class.all).to include('https://github.com')
  end
end
