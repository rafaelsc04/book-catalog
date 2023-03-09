require 'httparty'
require 'json'

class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def new; end

  def create
    if book_data
      Book.create(book_data)
      flash[:notice] = 'Livro adicionado :)'
    else
      flash[:alert] = 'Não encontrei nenhum livro com esse ISBN' 
    end

    redirect_to new_book_path
  end

  private

  def book_data
    response = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=isbn:#{params[:isbn]}&key=#{Rails.application.credentials[:google_api_key]}")

    data = JSON.parse(response.body).with_indifferent_access

    return false unless data[:items]

    { author: data[:items][0][:volumeInfo][:authors][0],
      title: data[:items][0][:volumeInfo][:title],
      page_count: data[:items][0][:volumeInfo][:pageCount],
      isbn: data[:items][0][:volumeInfo][:industryIdentifiers][1][:identifier] }
  end
end
