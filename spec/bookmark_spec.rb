require 'bookmark.rb'
describe Bookmark do
  let(:bookmark_hash) { { 'id' => 1, 'url' => 'https://stackoverflow.com', 'title' => 'stackoverflow' } }

  let(:bookmark) { described_class.create(bookmark_hash) }

  it 'returns the id' do
    p bookmark
    p bookmark.first
    expect(bookmark['id']).to eq('6')
  end

  it 'returns the title' do
    expect(bookmark['title']).to eq('stackoverflow')
  end

  it 'returns the url' do
    expect(bookmark['url']).to eq('https://stackoverflow.com')
  end
end
