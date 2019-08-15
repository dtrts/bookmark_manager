class Tag
  attr_reader :id, :content

  def initialize(tag)
    @id = tag['id']
    @content = tag['content']
  end

  def bookmarks(bookmark_class = Bookmark)
    bookmark_class.where_tag_id(tag_id: @id)
  end

  def self.find(id:)
    tag = DatabaseConnection.query("
      select
         id
        ,content
      from
        tags
      where
        id = #{id}
      ;").first
    Tag.new(tag)
  end

  def self.all
    DatabaseConnection.query('
        select
          id
          ,content
        from
          tags
        ;').map { |tag| Tag.new(tag) }
  end

  def self.create(content:)
    tag = DatabaseConnection.query("
      insert into
        tags (content)
      values (\'#{content}\') returning id, content
      ;").first
    Tag.new(tag)
  end

  def self.delete(id:)
    DatabaseConnection.query("
      delete
      from
        tags
      where
        id = #{id}
      ;")
  end

  def self.where_bookmark_id(bookmark_id:)
    DatabaseConnection.query("
      select
        c.id
        ,c.content
      from
        bookmarks a
          join
            bookmark_tags b
            on a.id  = b.bookmark_id
          join
            tags c
            on b.tag_id = c.id
      where
        a.id = #{bookmark_id}
      ").map { |tag| Tag.new(tag) }
  end
end
