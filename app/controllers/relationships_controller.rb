class RelationshipsController < ApplicationController
	before_filter :signed_in_user

	# or comment when using respond_to in actions
	respond_to :html, :js

	def create
		# @user = User.find(params[:relationship][:followed_id])
		# current_user.follow!(@user)
		# redirect_to @user

		# or with Ajax
		@user = User.find(params[:relationship][:followed_id]) # не розумію
		current_user.follow!(@user)
		# respond_to do |format|
		# 	format.html { redirect_to @user }
		# 	format.js
		# end

		# or comment when using respond_to in actions
		respond_with @user
	end

	def destroy
		# @user = Relationship.find(params[:id]).followed
		# current_user.unfollow!(@user)
		# redirect_to(@user)

		# or with Ajax
		@user = Relationship.find(params[:id]).followed # не розумію
		current_user.unfollow!(@user)
		# respond_to do |format|
		# 	format.html { redirect_to @user }
		# 	format.js
		# end

		# or comment when using respond_to in actions
		respond_with @user
	end
end
