class Comment
  attr_reader :id, :text, :bookmark_id

  def initialize(comment)
    @id = comment['id']
    @text = comment['text']
    @bookmark_id = comment['bookmark_id']
  end

  def self.create(text:, bookmark_id:)
    comment = DatabaseConnection.query("
      insert into
        comments (text ,bookmark_id)
      values (\'#{text}\',#{bookmark_id})
      returning
        id
        ,text
        ,bookmark_id
      ;").first
    Comment.new(comment)
  end

  def self.where_bookmark_id(bookmark_id:)
    DatabaseConnection.query("
      select
        id
        ,text
        ,bookmark_id
      from
        comments
      where
        bookmark_id = #{bookmark_id}
      order by
        id
      ;").map { |record| Comment.new(record) }
  end

  def self.delete(id:)
    DatabaseConnection.query("
      delete
      from
        comments
      where
        id = #{id}
      ;")
  end
end
