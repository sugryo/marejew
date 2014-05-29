# -*- coding: utf-8 -*-
# require 'bundler'
#
# Bundler.require
# self.active_record
# self.rakuten_web_service
# require 'date'
# require 'yaml'

require 'rakuten_web_service'
require 'active_record'
require 'date'
require 'yaml'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "./db/marejew.db"
  )

class Users < ActiveRecord::Base
end

class Books < ActiveRecord::Base
end

class Lendbooks < ActiveRecord::Base
end

module Database
  class Add
    class << self
      def user(users_name, users_class)
	Users.create(name: users_name, uclass: users_class, booklimit: 0)
      end

      def book(books_title, books_author, books_publisher, isbn)
	Books.create(title: books_title, author: books_author, publisher: books_publisher, isbn: isbn)
      end

      def isbn_book(isbn)
	rakuten_id = [application_id: "", affiliate_id: ""]
	RakutenWebService.configuration do |c|
	  c.application = rakuten_id[:application_id]
	  c.affiliate_id = rakuten_id[:affiliate_id]
	end
	books = RakutenWebService::Books::Book.search(isbn: isbn)
	books.each do |book|
	  title = book["title"]
	  author = book["author"]
	  publisher_name = book["publisherName"]
	  isbn = book["isbn"]
	  Books.create(title: title, author: author, publisher: publisher_name, isbn: isbn)
	end
      end

      def lend(users_id, books_number)
	lend_day = Date.today
	return_day = lend_day + 7
	
	lend = Lendbooks.new do |l|
	  l.users_id = users_id
	  l.books_id = books_number
	  l.lendday = lend_day.to_s
	  l.returnday = return_day.to_s
	end
	lend.save
      end

      def book_limit(users_id)
	users = Users.find(users_id)
	book_limit = users[:booklimit]
	book_limit += 1
	Users.update(users_id, booklimit: book_limit)
      end
    end
  end

  class Search
    class << self
      def user?(users_id)
	if Users.where(id: users_id)
	  true
	else
	  false
	end
      end

      def book?(books_number)
	if Books.find_by_id(books_number)
	  true
	else
	  false
	end
      end

      def lend?(books_number)
	if Lendbooks.find_by_books_id(books_number)
	  true
	else
	  false
	end
      end

      def book_limit?(users_id)
	begin
	  record = Users.find_by_id(users_id)
	  if record == nil
	    false
	  end
	  books_limit = record[:booklimit]
	  books_limit += 1
	  if books_limit <= 2
	    true
	  else
	    false
	  end
	rescue
	  false
	end
      end
    end
  end

  class Delete
    class << self
      def user(users_id)
	user = Users.find(users_id)
	user.destroy
      end

      def book(book_number)
	book = Books.find(book_number)
	book.destroy
      end

      def lend(books_number)
	lend = Lendbooks.find(books_number)
	lend.destroy
	return lend[:users_id]
      end

      def book_limit(users_id)
	users = Users.find(users_id)
	book_limit = users[:booklimit]
	book_limit -= 1
	Users.update(users_id, booklimit: book_limit)
      end
    end
  end
end
p Users.all
p Books.all
p Lendbooks.all
