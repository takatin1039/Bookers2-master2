class BookCommentsController < ApplicationController
	def create
		#コメントはcomment,book_id,user_idの３つのデータがあるのでそれらが代入するまではcreateされない
		book = Book.find(params[:book_id])
		#comment = PostComment.new(post_comment_params)
		#comment.user_id = current_user.idと下のコードは同じ
		comment = current_user.book_comments.new(book_comment_params) #ここでcommentとuser_idを代入
		comment.book_id = book.id #ここでbook_idを代入

		if comment.save
			flash[:notice] = "Comment was successfully created!"
			redirect_to request.referer
		else
			book_comments = BookComment.where(book_id: book.id)
	      	render '/books/show'
    end
	end
	def destroy
		book_comment = BookComment.find(params[:book_id])
		book_comment.destroy
		redirect_to request.referer
	end
	private
	def book_comment_params
		params.require(:book_comment).permit(:comment)
	end
end
