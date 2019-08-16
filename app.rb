require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'uri'
require_relative './lib/bookmark.rb'
require_relative './lib/comment.rb'
require_relative './lib/database_connection_setup.rb'
require_relative './lib/tag.rb'
require_relative './lib/bookmark_tag.rb'
require_relative './lib/user.rb'

class BookmarkManager < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Flash
  enable :method_override
  enable :sessions

  set :public_folder, File.dirname(__FILE__) + '/static'

  get '/style.css' do
    send_file '/views/style.css'
  end

  get '/' do
    'Bookmark Manager'
  end

  get '/bookmarks' do
    if flash[:bookmarks_by_tag]
      @bookmarks = Tag.find(id: flash[:bookmarks_by_tag]).bookmarks
      @show_home_button = true
    else
      @bookmarks = Bookmark.all
    end
    @user = User.find(id: session[:user_id])

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
    @bookmarks = Tag.find(id: params[:id]).bookmarks
    flash[:bookmarks_by_tag] = params[:id]
    redirect('/bookmarks')
    erb(:bookmarks)
  end

  # UPDATE BOOKMARK TAGS
  get '/bookmarks/:id/tags/update' do
    @tags = Tag.all
    @bookmark = Bookmark.find(id: params[:id])

    erb(:"bookmarks/tags/update")
  end

  put '/bookmarks/:id/tags' do
    @bookmark_id = params[:id]

    Tag.all.each do |tag|
      if params.key?(('tag' + tag.id.to_s).to_sym)
        BookmarkTag.create(bookmark_id: @bookmark_id, tag_id: tag.id)
      else
        BookmarkTag.delete(bookmark_id: @bookmark_id, tag_id: tag.id)
      end
    end

    redirect('/bookmarks')
  end

  # DELETE BOOKMARK TAGS
  delete '/bookmarks/:bookmark_id/tags/:tag_id' do
    BookmarkTag.delete(bookmark_id: params[:bookmark_id], tag_id: params[:tag_id])
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
  # USERS  ---------------------------------------------------------------------
  get '/users/create' do
    erb(:"users/create")
  end

  post '/users' do
    session[:user_id] = User.create(email_address: params[:email_address], username: params[:username], password: params[:password]).id
    redirect('/bookmarks')
  end

  get '/users/login' do
    erb(:"/users/login")
  end

  post '/users/login' do
    user = User.login(email_address: params[:email_address], password: params[:password])
    unless user
      flash[:invalid_password] = true
      redirect('/users/login')
    end

    session[:user_id] = user.id
    redirect('/bookmarks')
  end

  post '/users/logout' do
    session[:user_id] = nil
    redirect('/bookmarks')
  end
  # USERS  ---------------------------------------------------------------------

  run! if app_file == $PROGRAM_NAME
end
