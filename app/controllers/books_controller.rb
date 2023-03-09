require 'httparty'
require 'json'

class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def new; end

  def create
    redirect_to new_book_path, alert: 'Could not find book by ISBN' && return unless book_data

    Book.create(book_data)
    redirect_to new_book_path, notice: 'Successfully created book'
  end

  private

  def book_data
    response = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=isbn:#{params[:isbn]}&key=AIzaSyASd43pJPWdWn672p9G4zB2S2Qgf7hQpnM")

    data = JSON.parse(response.body).with_indifferent_access

    return false unless data[:items]

    { author: data[:items][0][:volumeInfo][:authors][0],
      title: data[:items][0][:volumeInfo][:title],
      page_count: data[:items][0][:volumeInfo][:pageCount],
      isbn: data[:items][0][:volumeInfo][:industryIdentifiers][1][:identifier] }
  end
end
