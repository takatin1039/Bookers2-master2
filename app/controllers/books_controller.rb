
class BooksController < ApplicationController

  before_action :authenticate_user!

  before_action :correct_book, only: [:edit]
  def index
  	@book = Book.new
  	@books = Book.all
  	@user = current_user
  end

  def show
    @book = Book.find(params[:id])
    @user = User.find(@book.user_id)
    @book_new = Book.new
    @book_comment = BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
  end


  def create
  	@book = Book.new(book_params)
  	@book.user_id = current_user.id
  	if @book.save
  		flash[:notice] = "Book was successfully created"
  		redirect_to book_path(@book)
  	else
  		@books = Book.all
  		@user = current_user
  		render :index
  	end
  end
  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "Book was successfully updated"
      redirect_to book_path(@book)
    else
      @books = Book.all
      @user = current_user
      render :edit
    end
  end
  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private
  def book_params
  	params.require(:book).permit(:title, :body)
  end

  def correct_book
    book = Book.find(params[:id])
    if book.user != current_user
      redirect_to books_path
    end
  end
end
