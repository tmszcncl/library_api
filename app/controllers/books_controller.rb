class BooksController < ApplicationController
  before_action :set_book, only: [ :show, :destroy, :borrow, :return ]

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

  def borrow
    if @book.borrowed?
      render json: { error: "Book is already borrowed" }, status: :unprocessable_entity
      return
    end

    reader = Reader.find_by(library_card_number: params[:reader_card_number])

    if reader.nil?
      render json: { error: "Reader not found" }, status: :not_found
      return
    end

    borrowing = @book.borrowings.new(reader: reader, borrowed_at: Time.current)

    if borrowing.save
      render json: borrowing, status: :created
    else
      render json: { errors: borrowing.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def return
    borrowing = @book.borrowings.find_by(returned_at: nil)

    if borrowing.nil?
      render json: { error: "Book is not currently borrowed" }, status: :unprocessable_entity
      return
    end

    if borrowing.update(returned_at: Time.current)
      render json: borrowing, status: :ok
    else
      render json: { errors: borrowing.errors.full_messages }, status: :unprocessable_entity
    end
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
