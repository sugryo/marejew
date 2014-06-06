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

class LendBooks < ActiveRecord::Base
end

module Database
  class User
    class << self
      def add(name, class_name)
	Users.create(name:      users_name,
	             uclass:    class_name,
	             booklimit: 0)
      end

      def have?(id)
	if Users.where(id: id)
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
        return_Day = lend_day + 7
        Lendbooks.create(users_id:  users_id,
	                books_id:  books_number,
	                lendday:   lend_day.to_s,
	                returnday: return_day.to_s)
      end

      def have?(books_number)
	if Lendbooks.find_by_books_id(books_number)
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
