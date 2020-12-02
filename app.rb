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
end

get '/' do
	erb 'Hello!'
end

get '/new' do
	erb :new
end

post '/new' do
	@content = params[:content]

	@error = 'Post is empty!' if @content == ''
	# return erb :new if @error != ''

	erb (@error !='') ? :new : "ok #{@content}"
end
