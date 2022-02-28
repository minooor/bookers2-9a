class BooksController < ApplicationController
before_action :authenticate_user!

  def show
    @book_new = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
    impressionist(@book, nil, unique: [:ip_address])

  end

  def index
    @book = Book.new
    @books = Book.all
    @user = current_user
    @books = Book.includes(:favorites).sort {|a,b| b.favorites.where(created_at: Time.current.all_week).size <=> a.favorites.where(created_at: Time.current.all_week).size}
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      @user = current_user
      render 'index'
    end
  end

  def edit
    @books = Book.all
    @book = Book.find(params[:id])
    if @book.user == current_user
      render "edit"
    else
      @books = Book.all
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: "You have updated book successfully."
    else
      @books = Book.all
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
