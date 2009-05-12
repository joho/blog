require 'rubygems'
require 'sinatra'
require 'rdiscount'
require 'hpricot'
require 'open-uri'

class Time
  def xmlschema
    strftime("%Y-%m-%dT%H:%M:%S%Z")
  end unless defined?(xmlschema)
end

class Post
  def self.all
    file_names.collect do |e|
      doc = Hpricot(load_html("posts/#{e}"))
      [e.split('.')[0], 
      doc.at('h2').inner_text] 
    end
  end
  
  def self.all_for_feed
    file_names[0, 10].collect do |e|
      html = load_html("posts/#{e}")
      doc = Hpricot(html)
      stat = File::Stat.new("posts/#{e}")
      
      details = { :file_name => e.split('.')[0],
                  :title => doc.at('h2').inner_text,
                  :published => stat.ctime,
                  :body => RDiscount.new(html).to_html }
      details[:updated] = stat.mtime if stat.mtime != stat.ctime
      
      details
    end
  end
  
  def self.file_names
    Dir.entries('posts').select do |entry| 
      entry =~ /\.md/
    end.sort_by do |file_name|
      File.ctime("posts/#{file_name}")
    end.reverse
  end
end

def load_html(file_path)
  file_contents = File.open(file_path, 'r') { |f| f.read }
  RDiscount.new(file_contents).to_html
end

get '/' do
  haml :index, :layout => false
end

get '/posts' do
  @posts = Post.all

  haml :posts
end

get '/posts/:file_name' do
  file_path = "posts/#{params[:file_name]}.md"
  halt 404 unless File.exist? file_path
  
  @content = load_html(file_path)
  
  haml :post
end

get '/feed.atom' do
  @posts = Post.all_for_feed
  @updated_date = @posts.first[:updated] || @posts.first[:published]
  content_type 'application/atom+xml'
  haml :feed, :layout => false
end

get '/styles.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :styles
end

get '/tramtracker' do
  open("http://tramtracker.com/#{params[:path]}").read
end

