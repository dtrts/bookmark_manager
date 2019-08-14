require 'comment.rb'
describe Comment do
  describe '.create' do
    it 'creates a new comment' do
      comment = Comment.create(bookmark_id: 1, text: 'Enough talking about google')
      expect(comment.id).to eq('4')
      expect(comment.text).to eq('Enough talking about google')
      expect(comment.bookmark_id).to eq('1')
    end
  end
  describe '.all(:bookmark_id)' do
    it 'returns all the comments for a particular bookmark_id' do
      comments = Comment.all(bookmark_id: 1)
      expect(comments.length).to eq(2)
      expect(comments.first.id).to eq('1')
      expect(comments.first.text).to eq('This is a handy search engine')
      expect(comments.first.bookmark_id).to eq('1')
      expect(comments.last.id).to eq('2')
      expect(comments.last.text).to eq('Watch out for your personal data')
      expect(comments.last.bookmark_id).to eq('1')
    end
  end
end
