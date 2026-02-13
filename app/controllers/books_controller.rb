class BooksController < ApplicationController
  before_action :set_book, only: [ :show, :destroy ]

  def index
    books = Book.all.includes(:borrowings)
    render json: books.as_json(methods: :status)
  end

  def show
    render json: @book.as_json(
      methods: :status,
      include: {
        borrowings: {
          include: {
            reader: { only: [ :full_name, :email, :library_card_number ] }
          },
          only: [ :borrowed_at, :returned_at ]
        }
      }
    )
  end

  def create
    book = Book.new(book_params)

    if book.save
      render json: book, status: :created
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    head :no_content
  end

  private

  def set_book
    @book = Book.includes(borrowings: :reader).find_by!(serial_number: params[:serial_number])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Book not found" }, status: :not_found
  end

  def book_params
    params.require(:book).permit(:title, :author, :serial_number)
  end
end
