require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'thin'
$LOAD_PATH << File.dirname(__FILE__)
require 'app'
run Marejew2::Application