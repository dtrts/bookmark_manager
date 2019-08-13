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

  get '/create_bookmark' do
    erb(:create_bookmark)
  end

  post '/create_bookmark' do
    Bookmarks.create(params[:url])
    redirect('/bookmarks')
  end

  run! if app_file == $PROGRAM_NAME
end
