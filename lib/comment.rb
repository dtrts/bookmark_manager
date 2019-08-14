class Comment
  attr_reader :id, :text, :bookmark_id

  def initialize(id:, text:, bookmark_id:)
    @id = id
    @text = text
    @bookmark_id = bookmark_id
  end

  def self.create(text:, bookmark_id:)
    record = DatabaseConnection.query("insert into comments (text ,bookmark_id) values (\'#{text}\',#{bookmark_id}) returning id,text,bookmark_id;").first
    Comment.new(id: record['id'], text: record['text'], bookmark_id: record['bookmark_id'])
  end

  def self.all(bookmark_id:)
    result = DatabaseConnection.query("select id, text, bookmark_id from comments where bookmark_id = #{bookmark_id} order by id")
    result.map { |record| Comment.new(id: record['id'], text: record['text'], bookmark_id: record['bookmark_id']) }
  end

  def self.delete(id:)
    DatabaseConnection.query("delete from comments where id = #{id};")
  end

  private

  def self.record_to_comment(record)
    Comment.new(id: record['id'], text: record['text'], bookmark_id: record['bookmark_id'])
  end
end
