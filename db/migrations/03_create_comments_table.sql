create table comments
  (id serial primary key,text varchar(240), bookmark_id integer references bookmarks(id) on delete cascade);