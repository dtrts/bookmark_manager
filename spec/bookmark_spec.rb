require 'bookmark.rb'
describe Bookmark do
  let(:bookmark_hash) { { id: 1, url: 'https://stackoverflow.com', title: 'stackoverflow' } }

  let(:bookmark) { described_class.create(bookmark_hash) }

  it 'returns the id' do
    expect(bookmark.id).to eq('6')
  end

  it 'returns the title' do
    expect(bookmark.title).to eq('stackoverflow')
  end

  it 'returns the url' do
    expect(bookmark.url).to eq('https://stackoverflow.com')
  end

  describe '.all' do
    it 'returns a list of bookmarks' do
      bookmarks = Bookmark.all
      expect(bookmarks.length).to eq 5
      expect(bookmarks.first).to be_a Bookmark
      expect(bookmarks.first.id).to eq '1'
      expect(bookmarks.first.title).to eq 'Goggle'
      expect(bookmarks.first.url).to eq 'www.google.com'
    end
  end
end
