# frozen_string_literal: true

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
		erb 'Hello!'
end

get '/new' do
		erb :new
end
