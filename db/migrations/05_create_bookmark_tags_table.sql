create table bookmark_tags (id serial primary key, bookmark_id integer references bookmarks(id),tag_id integer references tags(id));