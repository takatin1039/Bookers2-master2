class FavoritesController < ApplicationController
	def create
		book = Book.find(params[:book_id])
		favorite = current_user.favorites.new(book_id: book.id)
		favorite.save
		#リファラーとは、該当ページに遷移する直前に閲覧されていた参照元（遷移元・リンク元）ページのURLのことrequest.referrerが英語的には正しい
		redirect_to request.referer
	end
	def destroy
		book = Book.find(params[:book_id])
		favorite = current_user.favorites.find_by(book_id: book.id)
		favorite.destroy
		redirect_to request.referer
	end
	#リダイレクトの振り分け
	private
	def redirect
    case params[:redirect_id].to_i
    when 0
      redirect_to books_pathd
    when 1
      redirect_to book_path(book)
    end
  end
end
