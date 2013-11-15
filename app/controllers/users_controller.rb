class UsersController < ApplicationController
	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		# the same as 
		# @user = User.new(name: "..", email: "..", ..)

		if @user.save
			flash[:success] = "Welcome to the Social App!"
			redirect_to user_path(@user)
		else
			render 'new'
		end
	end
end
