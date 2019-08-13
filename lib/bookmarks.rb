require 'pg'

class Bookmarks
  def self.all
    conn = if ENV['ENVIRONMENT'] == 'test'
             PG.connect(dbname: 'bookmark_manager_test')
           else
             PG.connect(dbname: 'bookmark_manager')
            end
    conn.exec('select id,title,url from bookmarks').to_a
  end

  def self.create(options)
    conn = if ENV['ENVIRONMENT'] == 'test'
             PG.connect(dbname: 'bookmark_manager_test')
           else
             PG.connect(dbname: 'bookmark_manager')
     end
    url = options[:url]
    title = options[:title]

    conn.exec("insert into bookmarks (title,url) values (\'#{title}'\, \'#{url}\');")
  end
end
