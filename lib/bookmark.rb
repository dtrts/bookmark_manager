# require 'PG'
# require_relative './database_connection.rb'
# require_relative './comment.rb'

class Bookmark
  attr_reader :id, :url, :title

  def initialize(bookmark)
    @id = bookmark['id']
    @url = bookmark['url']
    @title = bookmark['title']
  end

  def comments(comment_class = Comment)
    comment_class.all(bookmark_id: @id)
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

  def self.tags(id:)
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
        a.id = #{id}
      ").map { |tag| Tag.new(tag) }
  end

  private

  def self.is_url?(url)
    # url =~ /\A#{URI.regexp(%w[http https])}\z/
    url =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/
  end
end
