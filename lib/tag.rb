class Tag
  attr_reader :id, :content
  def initialize(id:, content:)
    @id = id
    @content = content
  end

  def self.all
    DatabaseConnection.query('select id, content from tags').map { |tag| Tag.new(id: tag['id'], content: tag['content']) }
  end

  def self.create(content:)
    result = DatabaseConnection.query("insert into tags (content) values (\'#{content}\') returning id, content").first
    Tag.new(id: result['id'], content: result['content'])
  end

  def self.delete(id:)
    DatabaseConnection.query("delete from tags where id = #{id}")
  end

  def self.bookmarks(id:)
    DatabaseConnection.query("
      select
        c.id
        ,c.title
        ,c.url
      from
        tags a
          join
            bookmark_tags b
            on a.id = b.tag_id
          join
            bookmarks c
            on b.bookmark_id = c.id
      where
        a.id = #{id}
      ").map { |bookmark| Bookmark.new(id: bookmark['id'], title: bookmark['title'], url: bookmark['url']) }
  end
end
