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
  :database => "db/marejew.db"
  )

class Users < ActiveRecord::Base
end

class Books < ActiveRecord::Base
end

class Lendbooks < ActiveRecord::Base
end

module Database
  class User
    class << self
      def add(name, class_name)
	Users.create(name:      name,
	             uclass:    class_name,
	             booklimit: 0)
      end

      def show
	Users.all
      end

      def have?(id)
	if Users.find(id)
	  true
	else
	  false
	end
      end

      def delete(id)
	users_data = Users.find(id)
	users_data.destroy
      end
    end
  end

  class Book
    class << self
      def add(title, author, publisher, isbn)
	Books.create(title:     title,
	             author:    author,
	             publisher: publisher,
	             isbn:      isbn)
      end

      def show
	Books.all
      end

      def have?(number)
	if Books.find_by_id(number)
	  true
	else
	  false
	end
      end

      def delete(number)
	book_data = Books.find(number)
	book_data.destroy
      end
    end
  end

  class LendBook
    class << self
      def add(users_id, books_number)
        lend_day = Date.today
        return_day = lend_day + 7
        Lendbooks.create(users_id:  users_id,
	                books_id:  books_number,
	                lendday:   lend_day.to_s,
	                returnday: return_day.to_s)
      end

      def show
	Lendbooks.all
      end

      def have?(books_number)
	number = books_number.to_i
	if Lendbooks.find_by_books_id(number)
	  true
	else
	  false
	end
      end

      def delete(books_number)
	lendbooks_data = Lendbooks.find(books_number)
	lendbooks_data.destroy
	return lendbooks_data[:users_id]
      end
    end
  end

  class BookLimit
    class << self
      def add(users_id)
	users_data = Users.find(users_id)
	book_limit = users_data[:booklimit]
	book_limit += 1
	Users.update(users_id, booklimit: book_limit)
      end

      def limit?(users_id)
	begin
	  users_data = Users.find(users_id)
	  books_limit = users_data[:booklimit]
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

      def delete(users_id)
	users_data = Users.find(users_id)
	books_limit = users_data[:booklimit]
	books_limit -= 1
	Users.update(users_id, booklimit: books_limit)
      end
    end
  end
end
