require 'rubygems'
require 'sinatra'
require 'yaml'
require 'activerecord'
require 'digest/md5'

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
  def self.is_authenticated?(supplied_auth_key)
    hash_this_key == supplied_auth_key
  end
  
  def self.auth_key
    @@auth_key ||= YAML::load_file(File.dirname(__FILE__) + '/secret.yml')["auth_key"]
  end
  
  def self.hash_this_key(key = auth_key)
    Digest::MD5.hexdigest("--johnrules--#{key}")
  end
end

helpers do
  def ensure_author!
    halt 403, "Hell No!" unless Author.is_authenticated?(request.cookies['auth_key'])
  end
end

get '/' do
  haml :index, :layout => false
end

get "/huh" do
  Author.auth_key
end

get "/auth/#{Author.auth_key}" do
  set_cookie("auth_key", Author.hash_this_key)
  "welcome back, dr. falken"
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

# admin system

get '/admin/new_post' do
  ensure_author!
  "post for a post"
end

post '/admin/new_post' do
  ensure_author!
end

get '/admin/edit_post/:id' do
  ensure_author!
  @post = Post.find params[:id]
  "edit a post"
end

# personal hulu location crap avoider
get '/geoCheck' do
<<-EOL
<?xml version="1.0" encoding="UTF-8"?>
<geocheck>
<status>valid</status>
</geocheck>
EOL
end

get '/crossdomain.xml' do
<<-EOL
<?xml version="1.0"?>
<!-- used for controlling cross-domain data loading in Macromedia Flash -->
<cross-domain-policy>
  <allow-access-from domain="*" />
</cross-domain-policy>
EOL
end