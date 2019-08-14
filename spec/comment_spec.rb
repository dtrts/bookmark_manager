require 'comment.rb'
describe Comment do
  describe '.create' do
    it 'creates a new comment' do
      comment = Comment.new(bookmark_id: 1, text: 'Enough talking about google')
      expect(comment.id).to eq(4)
    end
  end
  describe '.all(:bookmark_id)' do
    it 'returns all the comments for a particular bookmark_id' do
      comments = Comment.all(bookmark_id: 1)
      expect(comments.length).to eq(2)
      expect(comments.first).to eq(id: 1, text: 'This is a handy search engine', bookmark_id: 1)
      expect(comments.last).to eq(id: 2, text: 'Watch out for your personal data', bookmark_id: 1)
    end
  end
end
