require_relative '../lib/bookmarks.rb'
describe Bookmarks do
  it 'shows list of bookmarks' do
    expect(described_class.all).to include('Goggle')
    expect(described_class.all).to include('FaceyB')
  end

  it 'adds a bookmark' do
    described_class.create(url: 'https://github.com', title: 'GitHub <3')
    expect(described_class.all).to include('GitHub <3')
  end
end
