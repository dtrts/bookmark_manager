require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'uri'
require_relative './lib/bookmark.rb'
require_relative './lib/comment.rb'
require_relative './lib/database_connection_setup.rb'
require_relative './lib/tag.rb'
require_relative './lib/bookmark_tag.rb'

class BookmarkManager < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Flash
  enable :method_override
  enable :sessions

  get '/' do
    'Bookmark Manager'
  end

  get '/bookmarks' do
    @bookmarks = Bookmark.all
    @tags = Tag.all
    erb(:bookmarks)
  end

  # TAGS  ----------------------------------------------------------------------

  # DELETE TAG
  delete '/tags/:id' do
    Tag.delete(id: params[:id])
    redirect('/bookmarks')
  end

  # CREATE TAG
  get '/tags/create' do
    erb(:"tags/create")
  end

  post '/tags/create' do
    Tag.create(content: params[:content])
    redirect('/bookmarks')
  end

  # SHOW SINGLE TAG
  get '/tags/:id' do
    @show_home_button = true
    @bookmarks = Tag.find(id: params[:id]).bookmarks
    @tags = Tag.all
    erb(:bookmarks)
  end

  # UPDATE BOOKMARK TAGS
  get '/bookmarks/:id/tags/update' do
    @tags = Tag.all
    @bookmark = Bookmark.find(id: params[:id])

    erb(:"bookmarks/tags/update")
  end

  put '/bookmarks/:id/tags' do
    @bookmark = Bookmark.find(id: params[:id])
    @tags = Tag.all
    @tags.each do |tag|
      # if tagID present => insert into table if doesn't exist
      # if tagID is not present ? delete
    end
    DatabaseConnection.query("delete from bookmark_tags where bookmark_id = #{params[:id]};")

    params.each do |key, value|
      next unless key.to_s.start_with?('tag')

      DatabaseConnection.query("
        insert into
          bookmark_tags (bookmark_id,tag_id)
          values (#{params[:id]},#{value});
      ")
    end
    redirect('/bookmarks')
  end

  # DELETE BOOKMARK TAGS
  delete '/bookmarks/:bookmark_id/tags/:tag_id' do
    DatabaseConnection.query("
      delete from bookmark_tags where bookmark_id = #{params[:bookmark_id]} and tag_id = #{params[:tag_id]};
      ")
    redirect('/bookmarks')
  end
  # TAGS  ----------------------------------------------------------------------
  # BOOKMARKS  -----------------------------------------------------------------
  # CREATE BOOKMARK
  get '/bookmarks/create' do
    erb(:"bookmarks/create")
  end

  post '/bookmarks/create' do
    unless Bookmark.create(url: params[:url], title: params[:title])
      flash[:invalid_url] = 'Invalid URL'
      redirect('/bookmarks/create')
    end
    redirect('/bookmarks')
  end

  # DELETE BOOKMARK
  delete '/bookmarks/:id' do
    Bookmark.delete(id: params[:id])
    redirect('/bookmarks')
  end

  # UPDATE BOOKMARK
  get '/bookmarks/:id/update' do
    @bookmark = Bookmark.find(id: params[:id].to_i)
    erb(:"bookmarks/update")
  end

  put '/bookmarks/:id' do
    unless Bookmark.update(id: params[:id], title: params[:title], url: params[:url])
      flash[:invalid_url] = 'Invalid URL'
      redirect("/bookmarks/#{params[:id]}/update")
    end

    redirect('/bookmarks')
  end
  # BOOKMARKS  -----------------------------------------------------------------

  # COMMENTS  ------------------------------------------------------------------

  # CREATE COMMENT
  get '/bookmarks/:id/comments/create' do
    @bookmark_id = params[:id]
    erb(:"bookmarks/comments/create")
  end

  post '/bookmarks/:id/comments/create' do
    Comment.create(bookmark_id: params[:id], text: params[:text])
    redirect('/bookmarks')
  end

  # DELETE COMMENT
  delete '/bookmarks/:bookmark_id/comments/:comment_id' do
    Comment.delete(id: params[:comment_id])
    redirect('/bookmarks')
  end
  # COMMENTS  ------------------------------------------------------------------

  run! if app_file == $PROGRAM_NAME
end
