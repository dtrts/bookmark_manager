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

  get '/add_bookmark' do
    erb(:add_bookmark)
  end

  post '/add_bookmark' do
    Bookmarks.add(params[:url])
    redirect('/bookmarks')
  end

  run! if app_file == $PROGRAM_NAME
end
