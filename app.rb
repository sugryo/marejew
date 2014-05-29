# -*- coding: utf-8 -*-
# require 'bundler'
#
# Bundler.require
# self.sinatra/base
# self.slim
# self.sinatra/reloader
# self.thin
# require './db'

require 'sinatra/base'
require 'slim'
require 'sinatra/reloader'
require 'thin'
require './db'

module Marejew2
  class Application < Sinatra::Base
    enable :sessions
    get "/" do
      @title = "Home"
      @active = "home"
      slim :index
    end

    get "/lend" do
      @title = "貸出"
      @active = "lend"
      slim :lend
    end

    get "/return" do
      @title = "返却"
      @active = "return"
      slim :return
    end

    post "/lend_second" do
      users_id = params[:users_id]
      session[:users_id] = nil
      if Database::Search.user?(users_id) && Database::Search.book_limit?(users_id)
	puts "OK"
	session[:users_id] = users_id
	@title = "貸出"
	@active = "lend"
	slim :lend_second
      else
	redirect :lend
      end
    end

    post "/lend_finished" do
      books_number = params[:books_number]
      if session[:users_id]
        if Database::Search.book?(books_number) && !Database::Search.lend?(books_number)
          Database::Add.lend(session[:users_id], books_number)
	  Database::Add.book_limit(session[:users_id])
	  @title = "貸出完了"
	  @active = "lend"
	  slim :lend_finished
	else
	  redirect :lend
	end
      else
	redirect :lend
      end
    end

    post "/return_finished" do
      books_number = params[:books_number]
      if Database::Search.lend?(books_number)
	users_id = Database::Delete.lend(books_number)
	Database::Delete.book_limit(users_id)
	@title = "返却完了"
	@active = "return"
	slim :return_finished
      else
	redirect :return
      end
    end
  end
end
