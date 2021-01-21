class ApplicationController < ActionController::Base
	#name認証
	before_action :configure_permitted_parameters, if: :devise_controller?

	#サインインとサインアップ両方の遷移先
	def after_sign_in_path_for(resource)
 		 user_path(current_user)
	end
	#サインアウト後の遷移先
	def after_sign_out_path_for(resource)
	  	root_path
	end

	protected
	#デフォルト以外のカラムを認証
	def configure_permitted_parameters
	    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email])
	    devise_parameter_sanitizer.permit(:sign_in, keys: [:name, :password])
	end
end
