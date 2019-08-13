require 'PG'
class Bookmark
  attr_reader :id, :url, :title

  def initialize(bookmark_record)
    @id = bookmark_record[:id]
    @url = bookmark_record[:url]
    @title = bookmark_record[:title]
  end

  def self.all
    conn = if ENV['ENVIRONMENT'] == 'test'
             PG.connect(dbname: 'bookmark_manager_test')
           else
             PG.connect(dbname: 'bookmark_manager')
            end
    conn.exec('select id,title,url from bookmarks').map do |bookmark|
      Bookmark.new(id: bookmark['id'], title: bookmark['title'], url: bookmark['url'])
    end
  end

  def self.create(bookmark_record)
    conn = if ENV['ENVIRONMENT'] == 'test'
             PG.connect(dbname: 'bookmark_manager_test')
           else
             PG.connect(dbname: 'bookmark_manager')
           end
    url = bookmark_record[:url]
    title = bookmark_record[:title]

    result = conn.exec("insert into bookmarks (title,url) values (\'#{title}'\, \'#{url}\') returning id, url, title;").first
    Bookmark.new(id: result['id'], title: result['title'], url: result['url'])
  end

  def self.delete(id:)
    conn = if ENV['ENVIRONMENT'] == 'test'
             PG.connect(dbname: 'bookmark_manager_test')
           else
             PG.connect(dbname: 'bookmark_manager')
    end

    conn.exec("delete from bookmarks where id = #{id};")
  end

  def self.find(id:)
    conn = if ENV['ENVIRONMENT'] == 'test'
             PG.connect(dbname: 'bookmark_manager_test')
           else
             PG.connect(dbname: 'bookmark_manager')
    end

    result = conn.exec("select id,title,url from bookmarks where id = #{id};").first

    Bookmark.new(id: result['id'], title: result['title'], url: result['url'])
  end

  def self.update(id:, title:, url:)
    conn = if ENV['ENVIRONMENT'] == 'test'
             PG.connect(dbname: 'bookmark_manager_test')
           else
             PG.connect(dbname: 'bookmark_manager')
    end

    if !!title && !title.empty?
      conn.exec("update bookmarks set title = \'#{title}\' where id = #{id};")
    end

    if !!url && !url.empty?
      conn.exec("update bookmarks set url = \'#{url}\' where id = #{id};")
    end

    find(id: id)
  end
end
