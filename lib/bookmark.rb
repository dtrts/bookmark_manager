require 'PG'
# require_relative './database_connection.rb'

class Bookmark
  attr_reader :id, :url, :title

  def initialize(bookmark_record)
    @id = bookmark_record[:id]
    @url = bookmark_record[:url]
    @title = bookmark_record[:title]
  end

  def self.all
    DatabaseConnection.query('select id,title,url from bookmarks').map do |bookmark|
      Bookmark.new(id: bookmark['id'], title: bookmark['title'], url: bookmark['url'])
    end
  end

  def self.create(bookmark_record)
    url = bookmark_record[:url]
    title = bookmark_record[:title]

    result = DatabaseConnection.query("insert into bookmarks (title,url) values (\'#{title}'\, \'#{url}\') returning id, url, title;").first
    Bookmark.new(id: result['id'], title: result['title'], url: result['url'])
  end

  def self.delete(id:)
    DatabaseConnection.query("delete from bookmarks where id = #{id};")
  end

  def self.find(id:)
    result = DatabaseConnection.query("select id,title,url from bookmarks where id = #{id};").first

    Bookmark.new(id: result['id'], title: result['title'], url: result['url'])
  end

  def self.update(id:, title:, url:)
    if !!title && !title.empty?
      DatabaseConnection.query("update bookmarks set title = \'#{title}\' where id = #{id};")
    end

    if !!url && !url.empty?
      DatabaseConnection.query("update bookmarks set url = \'#{url}\' where id = #{id};")
    end

    find(id: id)
  end
end
