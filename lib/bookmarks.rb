require 'pg'

class Bookmarks
  def self.all
    conn = if ENV['ENVIRONMENT'] == 'test'
             PG.connect(dbname: 'bookmark_manager_test')
           else
             PG.connect(dbname: 'bookmark_manager')
            end
    result = conn.exec('select url from bookmarks')
    result.map { |row| row['url'] }
  end

  def self.add(url)
    conn = if ENV['ENVIRONMENT'] == 'test'
             PG.connect(dbname: 'bookmark_manager_test')
           else
             PG.connect(dbname: 'bookmark_manager')
     end

    conn.exec("insert into bookmarks (url) values (\'#{url}\');")
  end
end
