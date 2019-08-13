require 'bookmark.rb'
describe Bookmark do
  let(:bookmark_hash) { { id: 1, url: 'https://stackoverflow.com', title: 'stackoverflow' } }

  subject { described_class.new(bookmark_hash) }

  it 'returns the id' do
    expect(subject.id).to eq(1)
  end

  it 'returns the title' do
    expect(subject.title).to eq('stackoverflow')
  end

  it 'returns the url' do
    expect(subject.url).to eq('https://stackoverflow.com')
  end
end
