class BookmarkTag
  attr_reader :id, :bookmark_id, :tag_id
  def initialize(bookmark_tag)
    @id = bookmark_tag['id']
    @bookmark_id = bookmark_tag['bookmark_id']
    @tag_id = bookmark_tag['tag_id']
  end

  def self.create(bookmark_id:, tag_id:)
    bookmark_tag = DatabaseConnection.query("
      insert into
        bookmark_tags
          (bookmark_id,tag_id)
        select
          *
        from
        (
          values (#{bookmark_id}, #{tag_id})
        ) a (bookmark_id ,tag_id)
        except
        select
          bookmark_id
          ,tag_id
        from
          bookmark_tags
        returning
           id
          ,bookmark_id
          ,tag_id
      ;").first

    return false unless bookmark_tag

    BookmarkTag.new(bookmark_tag)
  end

  def self.delete(bookmark_id:, tag_id:)
    DatabaseConnection.query("
      delete
      from
        bookmark_tags
      where
        bookmark_id = #{bookmark_id}
        and tag_id = #{tag_id}
      ;")
  end

  def self.find_on_tag(id:)
    DatabaseConnection.query("
      select
        id
        ,bookmark_id
        ,tag_id
      from
        bookmark_tags
      where
        tag_id = #{id}
      ;").map { |bookmark_tag| BookmarkTag.new(bookmark_tag) }
  end

  def self.find_on_bookmark(id:)
    DatabaseConnection.query("
      select
        id
        ,bookmark_id
        ,tag_id
      from
        bookmark_tags
      where
        bookmark_id = #{id}
      ;").map { |bookmark_tag| BookmarkTag.new(bookmark_tag) }
  end
end
