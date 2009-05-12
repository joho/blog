require 'rubygems'
require 'sinatra'
require 'rdiscount'
require 'hpricot'
require 'open-uri'

def load_html(file_path)
  file_contents = File.open(file_path, 'r') { |f| f.read }
  RDiscount.new(file_contents).to_html
end

get '/' do
  haml :index, :layout => false
end

get '/posts' do
  file_names = Dir.entries('posts').select do |entry| 
    entry =~ /\.md/
  end.sort_by do |file_name|
    File.ctime("posts/#{file_name}")
  end
  
  @posts = file_names.collect do |e|
    doc = Hpricot(load_html("posts/#{e}"))
    [e.split('.')[0], 
    doc.at('h2').inner_text] 
  end

  haml :posts
end

get '/posts/:file_name' do
  file_path = "posts/#{params[:file_name]}.md"
  halt 404 unless File.exist? file_path
  
  @content = load_html(file_path)
  
  haml :post
end

get '/styles.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :styles
end

get '/tramtracker' do
  open("http://tramtracker.com/#{params[:path]}").read
end

