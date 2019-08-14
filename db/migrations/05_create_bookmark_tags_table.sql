create table if not exists bookmark_tags
  (id serial primary key,bookmark_id integer references bookmarks(id) on delete cascade,tag_id integer references tags(id) on delete cascade);