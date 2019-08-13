def prepare_test_database
  conn = PG.connect(dbname: 'bookmark_manager_test')
  conn.exec('drop table if exists bookmarks;')

  create_table_bookmarks = File.open('./db/migrations/01_create_bookmarks_table.sql', &:read)
  conn.exec(create_table_bookmarks)

  conn.exec('truncate bookmarks;')
  conn.exec('
    insert into bookmarks (title, url)
    values
       (\'Goggle\',\'www.google.com\')
      ,(\'FaceyB\',\'www.facebook.com\')
      ,(\'MakersQueens\',\'http://www.makersacademy.com\')
      ,(\'Shut it down\',\'http://www.destroyallsoftware.com\')
      ,(\'Goglle\',\'http://www.google.com\')
    ')
end
