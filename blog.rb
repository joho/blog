require 'rubygems'
require 'sinatra'
require 'activerecord'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :dbfile =>  'blog.db'
)

class Post < ActiveRecord::Base
  set_table_name :blog_posts
  
  def summary
    body[0, [100, body.size].min]
  end
end

class Author
  def self.authenticate(username, password)
  end
end

get '/' do
  haml :index, :layout => false
end

get '/posts/new' do
  "this is where you'll write a post"
end

post '/posts/new' do
  "post for a post"
end

get '/posts/:id/edit' do
  @post = Post.find params[:id]
  "edit a post"
end

post '/posts/:id/edit' do
  @post = Post.find params[:id]
end

get '/posts' do
  @posts = Post.all :order => 'created_at DESC'
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
