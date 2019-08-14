require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'
require_relative './lib/bookmark.rb'
require_relative './lib/database_connection_setup.rb'

class BookmarkManager < Sinatra::Base
  register Sinatra::Reloader
  enable :method_override
  enable :sessions

  get '/' do
    'Bookmark Manager'
  end

  get '/bookmarks' do
    @bookmarks = Bookmark.all
    erb(:bookmarks)
  end

  # CREATE
  get '/bookmarks/create' do
    erb(:"bookmarks/create")
  end

  post '/bookmarks/create' do
    Bookmark.create(url: params[:url], title: params[:title])
    redirect('/bookmarks')
  end

  # REST

  delete '/bookmarks/:id' do
    Bookmark.delete(id: params[:id])
    redirect('/bookmarks')
  end

  get '/bookmarks/:id/update' do
    @bookmark = Bookmark.find(id: params[:id].to_i)
    erb(:"bookmarks/update")
  end

  put '/bookmarks/:id' do
    Bookmark.update(id: params[:id], title: params[:title], url: params[:url])
    redirect('/bookmarks')
  end

  run! if app_file == $PROGRAM_NAME
end
