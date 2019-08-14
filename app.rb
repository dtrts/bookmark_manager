require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'uri'
require_relative './lib/bookmark.rb'
require_relative './lib/database_connection_setup.rb'

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
    erb(:bookmarks)
  end

  # CREATE
  get '/bookmarks/create' do
    erb(:"bookmarks/create")
  end

  post '/bookmarks/create' do
    unless params[:url] =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/
      flash[:invalid_url] = 'Invalid URL'
      redirect('/bookmarks/create')
    end

    Bookmark.create(url: params[:url], title: params[:title])
    redirect('/bookmarks')
  end

  # DELETE

  delete '/bookmarks/:id' do
    Bookmark.delete(id: params[:id])
    redirect('/bookmarks')
  end

  # UPDATE

  get '/bookmarks/:id/update' do
    @bookmark = Bookmark.find(id: params[:id].to_i)
    erb(:"bookmarks/update")
  end

  put '/bookmarks/:id' do
    unless params[:url] =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/
      flash[:invalid_url] = 'Invalid URL'
      redirect("/bookmarks/#{params[:id]}/update")
    end

    Bookmark.update(id: params[:id], title: params[:title], url: params[:url])
    redirect('/bookmarks')
  end

  run! if app_file == $PROGRAM_NAME
end
