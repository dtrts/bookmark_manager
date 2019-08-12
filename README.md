

## Setting up the database

To use this app you will have to also install the database.
Postgres is being used.
In shell:
```
$ psql
```
In Postgres:
```
# CREATE DATABASE bookmark_manager;
# \c bookmark_manager;
```
Then run the sql scripts in the `~/db/migrations` folder in order.

```
# \i '01_create_bookmarks_table.sql'
```
