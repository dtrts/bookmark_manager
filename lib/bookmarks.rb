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
end
