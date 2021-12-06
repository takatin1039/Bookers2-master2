class RelationshipsController < ApplicationController
	before_action :set_user , only:[:create,:destroy]

	def create
		following = current_user.follow(@user)
		if following.save
			flash[:success] = 'ユーザーをフォローしました。'
			redirect_to request.referer
		else
			flash[:alert] = 'ユーザーのフォローに失敗しました。'
			redirect_to request.referer
		end

	end
	def destroy
		following = current_user.unfollow(@user)
		if following.destroy
			flash[:success] = 'ユーザーのフォローを解除しました。'
			redirect_to request.referer
		else
			flash.now[:alert] = 'ユーザーのフォロー解除に失敗しました。'
			redirect_to request.referer
		end


	end

	def follows
		user = User.find(params[:user_id])
    	@users = user.followings
	end

	def followers
		user = User.find(params[:user_id])
    	@users = user.followers
	end

	private

		def set_user
			@user = User.find(params[:follow_id])
		end

end

