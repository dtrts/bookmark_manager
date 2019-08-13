require 'sinatra/base'
require 'sinatra/reloader'
require_relative './lib/bookmarks.rb'

class BookmarkManager < Sinatra::Base
  register Sinatra::Reloader

  get '/' do
    'Bookmark Manager'
  end

  get '/bookmarks' do
    @bookmarks = Bookmarks.all
    erb(:bookmarks)
  end

  get '/bookmarks/create' do
    erb(:"bookmarks/create")
  end

  post '/bookmarks/create' do
    Bookmarks.create(params[:url])
    redirect('/bookmarks')
  end

  run! if app_file == $PROGRAM_NAME
end
