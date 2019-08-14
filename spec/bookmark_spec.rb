require 'bookmark.rb'
describe Bookmark do
  let(:bookmark_hash) { { id: 1, url: 'https://stackoverflow.com', title: 'stackoverflow' } }

  let(:bookmark) { described_class.create(bookmark_hash) }

  describe '.create' do
    it 'returns false if url is invalid' do
      expect(described_class.create(url: 'Bad URL', title: 'Title')).to eq(false)
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
      bookmark = Bookmark.create(title: 'A titleeee', url: 'https://alllowerca.se')

      expect(Bookmark.find(id: bookmark.id).title).to eq('A titleeee')

      Bookmark.update(id: bookmark.id, title: 'A title', url: 'https://alllowerca.se/alloneword')
      expect(Bookmark.find(id: bookmark.id).title).to eq('A title')
      expect(Bookmark.find(id: bookmark.id).url).to eq('https://alllowerca.se/alloneword')
    end

    it 'doesn\'t update with invalid url' do
      bookmark = Bookmark.create(title: 'A titleeee', url: 'https://alllowerca.se')

      expect(Bookmark.find(id: bookmark.id).title).to eq('A titleeee')

      expect(Bookmark.update(id: bookmark.id, title: 'A title', url: 'bad url')).to eq(false)
    end
  end

  describe '.comments' do
    # returns an array of comment
    bookmark = Bookmark.find(id: 1)
    expect(bookmark.comments).to include(['This is a handy search engine', 'Watch out for your personal data'])
  end
end
