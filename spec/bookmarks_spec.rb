require_relative '../lib/bookmarks.rb'
describe Bookmarks do
  it 'shows list of bookmarks' do
    expect(described_class.all).to include(include('title' => 'Goggle'))
    expect(described_class.all).to include(include('title' => 'FaceyB'))
  end

  it 'adds a bookmark' do
    described_class.create(url: 'https://github.com', title: 'GitHub <3')
    expect(described_class.all).to include(include('title' => 'GitHub <3', 'url' => 'https://github.com'))
  end
end
