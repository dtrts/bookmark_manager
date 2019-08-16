def persisted_data(table:, id:)
  DatabaseConnection.query("SELECT * FROM #{table} WHERE id = '#{id}';")
end

def prepare_test_database
  conn = PG.connect(dbname: 'bookmark_manager_test')

  conn.exec('drop table if exists bookmark_tags;')
  conn.exec('drop table if exists tags;')
  conn.exec('drop table if exists comments;')
  conn.exec('drop table if exists bookmarks;')
  conn.exec('drop table if exists users;')

  create_table_bookmarks     = File.open('./db/migrations/01_create_bookmarks_table.sql', &:read)
  create_table_comments      = File.open('./db/migrations/03_create_comments_table.sql', &:read)
  create_table_tags          = File.open('./db/migrations/04_create_tags_table.sql', &:read)
  create_table_bookmark_tags = File.open('./db/migrations/05_create_bookmark_tags_table.sql', &:read)
  create_table_users = File.open('./db/migrations/06_create_users_table.sql', &:read)
  conn.exec(create_table_bookmarks)
  conn.exec(create_table_comments)
  conn.exec(create_table_tags)
  conn.exec(create_table_bookmark_tags)
  conn.exec(create_table_users)

  # Inserting BOOKMARKS
  conn.exec('
    insert into
      bookmarks
        (title ,url)
    values
       (\'Goggle\'       ,\'www.google.com\')
      ,(\'FaceyB\'       ,\'www.facebook.com\')
      ,(\'MakersQueens\' ,\'http://www.makersacademy.com\')
      ,(\'Shut it down\' ,\'http://www.destroyallsoftware.com\')
      ,(\'Goglle\'       ,\'http://www.google.com\')
    ')
  # Inserting COMMENTS
  conn.exec('
    insert into
      comments
        (text ,bookmark_id)
    values
       (\'This is a handy search engine\',1)
      ,(\'Watch out for your personal data\',1)
      ,(\'Yaaaaas\',3)
    ')
  # Inserting TAGS
  conn.exec('
    insert into
      tags
        (content)
    values
       (\'Great!\')
      ,(\'Good\')
      ,(\'Bad\')
      ,(\'Read\')
      ,(\'ToRead\')
    ')
  # Inserting BOOKMARK_TAGS
  conn.exec('
    insert into
      bookmark_tags
        (bookmark_id ,tag_id)
    values
       (1,3) -- goggle, bad
      ,(1,4) -- goggle, read
      ,(2,3) -- faceyb, bad
      ,(3,1) -- makers, great
      ,(3,5) -- makers, not read
      ,(4,5) -- shit it down, not read
      ')
end
