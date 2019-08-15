# require 'PG'
# require_relative './database_connection.rb'
# require_relative './comment.rb'
require_relative './tag.rb'

class Bookmark
  attr_reader :id, :url, :title

  def initialize(bookmark)
    @id = bookmark['id']
    @url = bookmark['url']
    @title = bookmark['title']
  end

  def comments(comment_class = Comment)
    comment_class.where_bookmark_id(bookmark_id: @id)
  end

  def tags(tag_class = Tag)
    tag_class.where_bookmark_id(bookmark_id: @id)
  end

  def self.where_tag_id(tag_id:)
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
        a.id = #{tag_id}
      ;").map { |bookmark| Bookmark.new(bookmark) }
  end

  def include_tag?(tag)
    current_tags = tags
    current_tags.each do |current_tag|
      return true if current_tag.id == tag.id && current_tag.content == tag.content
    end
    false
  end

  def self.all
    DatabaseConnection.query('select id,title,url from bookmarks order by id').map do |bookmark|
      Bookmark.new(bookmark)
    end
  end

  def self.create(bookmark_record)
    url = bookmark_record[:url]
    return false unless is_url?(url)

    title = bookmark_record[:title]

    bookmark = DatabaseConnection.query("insert into bookmarks (title,url) values (\'#{title}'\, \'#{url}\') returning id, url, title;").first
    Bookmark.new(bookmark)
  end

  def self.delete(id:)
    DatabaseConnection.query("delete from bookmarks where id = #{id};")
  end

  def self.find(id:)
    bookmark = DatabaseConnection.query("select id,title,url from bookmarks where id = #{id};").first

    Bookmark.new(bookmark)
  end

  def self.update(id:, title:, url:)
    return false unless is_url?(url)

    if !!title && !title.empty?
      DatabaseConnection.query("update bookmarks set title = \'#{title}\' where id = #{id};")
    end

    if !!url && !url.empty?
      DatabaseConnection.query("update bookmarks set url = \'#{url}\' where id = #{id};")
    end

    find(id: id)
  end

  private

  def self.is_url?(url)
    # url =~ /\A#{URI.regexp(%w[http https])}\z/
    url =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/
  end
end
