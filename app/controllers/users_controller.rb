class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy,
										  :following, :followers]
	before_filter :unsigned_user,  only: [:new, :create]
	before_filter :correct_user,   only: [:edit, :update]
	before_filter :admin_user,     only: :destroy

	def index
		@users = User.paginate(page: params[:page], per_page: 10)
		# when changing :per_page count, change it in user_pages_spec.rb "pagination"
	end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page], per_page: 6)
		# when changing :per_page count, change it in static_pages_spec.rb
		# "pagination in user's feed"
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		# the same as 
		# @user = User.new(name: "..", email: "..", ..)

		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Social App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated"
			sign_in @user
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User destroyed."
		redirect_to users_url
	end

	def following
		@title = 'Following'
		@user = User.find(params[:id])
		@users = @user.followed_users.paginate(page: params[:page])
		render 'show_follow'
	end

	def followers
		@title = 'Followers'
		@user = User.find(params[:id])
		@users = @user.followers.paginate(page: params[:page])
		render 'show_follow'
	end

	private
		def unsigned_user
			if signed_in?
				redirect_to root_path, notice: "You already have an account"
			end
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end

		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
end
