class BooksController < ApplicationController
  def create
    book = Book.new(book_params)

    if book.save
      render json: book, status: :created
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :author, :serial_number)
  end
end
