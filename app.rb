# frozen_string_literal: true

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db 
	@db = SQLite3::Database.new 'lepra.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS posts
	 (
		"id"  INTEGER PRIMARY KEY AUTOINCREMENT,
		"created_date"  DATE,
		"content" TEXT
	  )'

	  @db.execute 'CREATE TABLE IF NOT EXISTS comments
	 (
		"id"  INTEGER PRIMARY KEY AUTOINCREMENT,
		"created_date"  DATE,
		"content" TEXT,
		"post_id" INTEGER
	  )'
end

get '/' do
	@results = @db.execute 'select * from posts order by id desc --'

	erb :index
end

get '/new' do
	erb :new
end

post '/new' do
	@content = params[:content]

	if @content == ''
		@error = 'Post is empty!' 
		return erb :new
	end
	# return erb :new if @error != ''
	
	@db.execute 'insert into posts 
	(content, created_date)
	 values (?, datetime())', [@content]

	redirect to '/'
end

get '/post/:post_id' do
	post_id = params[:post_id]

	results = @db.execute 'select * from posts where id=?', [post_id]
	@row = results[0]

	@comments = @db.execute 'select * from comments where post_id=? order by created_date desc --', [post_id]

	erb :post
end

post '/post/:post_id' do
	@com = params[:com]
	post_id = params[:post_id]

	@db.execute 'insert into comments
	 (created_date, content, post_id)
	  values (datetime(), ?, ?)', [@com, post_id]
	
	redirect to "/post/#{post_id}"
end
