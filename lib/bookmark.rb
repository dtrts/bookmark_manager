class Bookmark
  attr_reader :id, :url, :title

  def self.create(bookmark_record)
    conn = if ENV['ENVIRONMENT'] == 'test'
             PG.connect(dbname: 'bookmark_manager_test')
           else
             PG.connect(dbname: 'bookmark_manager')
           end
    url = bookmark_record['url']
    title = bookmark_record['title']

    conn.exec("insert into bookmarks (title,url) values (\'#{title}'\, \'#{url}\') returning id, url, title;").first
  end
end
