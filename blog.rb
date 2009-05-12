require 'rubygems'
require 'sinatra'
require 'yaml'
require 'activerecord'
require 'digest/md5'
require 'rdiscount'
require 'hpricot'

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

get '/' do
  haml :index, :layout => false
end

get '/posts' do
  file_names = %w(test.md)
  @posts = file_names.collect { |e| [e.split('.')[0], 'blah blah blah'] }

  haml :posts
end

get '/posts/:file_name' do
  file_path = "posts/#{params[:file_name]}.md"
  head 404 unless File.exist? file_path
  
  file_contents = File.open(file_path, 'r') { |f| f.read }
  @content = RDiscount.new(file_contents).to_html
  
  haml :post
end

get '/styles.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :styles
end

