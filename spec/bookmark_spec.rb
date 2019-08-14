require 'bookmark.rb'
describe Bookmark do
  let(:bookmark_hash) { { id: 1, url: 'https://stackoverflow.com', title: 'stackoverflow' } }

  let(:bookmark) { described_class.create(bookmark_hash) }

  describe '.create' do
    it 'checks for valid URLS' do
      expect(described_class.new(url: 'Bad URL', title: 'Title')).to eq(false)
    end
  end

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
      # check spec helper for values inserted
      bookmarks = Bookmark.all
      expect(bookmarks.length).to eq 5
      expect(bookmarks.first).to be_a Bookmark
      expect(bookmarks.first.id).to eq '1'
      expect(bookmarks.first.title).to eq 'Goggle'
      expect(bookmarks.first.url).to eq 'www.google.com'
    end
  end

  describe '.delete' do
    it 'deletes a record' do
      Bookmark.delete(id: 1)
      bookmarks = Bookmark.all
      expect(bookmarks.length).to eq 4
    end
  end
  describe '.find' do
    it 'finds a record' do
      bookmark = Bookmark.find(id: 1)
      expect(bookmark.id).to eq('1')
      expect(bookmark.title).to eq('Goggle')
      expect(bookmark.url).to eq('www.google.com')
    end
  end
  describe '.update' do
    it 'updates a record' do
      bookmark = Bookmark.create(title: 'A titleeee', url: 'A URL')

      expect(Bookmark.find(id: bookmark.id).title).to eq('A titleeee')

      Bookmark.update(id: bookmark.id, title: 'A title', url: 'a better url')
      expect(Bookmark.find(id: bookmark.id).title).to eq('A title')
      expect(Bookmark.find(id: bookmark.id).url).to eq('a better url')
    end
  end
end
