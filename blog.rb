require 'rubygems'
require 'sinatra'
require 'activerecord'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :dbfile =>  'blog.db'
)

class Post < ActiveRecord::Base
  set_table_name :blog_posts
end

get '/' do
  haml :index
end

get '/posts/' do
  @posts = Post.all :order => 'created_at'
  haml :posts
end

get '/posts/:id' do
  @post = Post.find params[:id]
  haml :post
end

get '/styles.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :styles
end
