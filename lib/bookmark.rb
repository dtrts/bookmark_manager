class Bookmark
  attr_reader :id, :url, :title
  def initialize(bookmark_record)
    @id = bookmark_record['id']
    @url = bookmark_record['url']
    @title = bookmark_record['title']
  end
end
