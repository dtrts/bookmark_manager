def prepare_test_database
  conn = PG.connect(dbname: 'bookmark_manager_test')
  conn.exec('drop table if exists bookmarks;')

  create_table_bookmarks = File.open('./db/migrations/01_create_bookmarks_table.sql', &:read)
  conn.exec(create_table_bookmarks)

  conn.exec('truncate bookmarks;')
  conn.exec('
    insert into bookmarks (url)
    values
       (\'www.google.com\')
      ,(\'www.facebook.com\')
      ,(\'http://www.makersacademy.com\')
      ,(\'http://www.destroyallsoftware.com\')
      ,(\'http://www.google.com\')
    ')
end
