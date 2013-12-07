class SessionsController < ApplicationController
	def new
	end

	def create
		# use params[:email] / params[:password]					 -> form_tag
		# use params[:session][:email] / params[:session][:password] -> form_for
		# form is located in app/views/sessions/new.html.erb

		user = User.find_by_email(params[:email].downcase)

		if user && user.authenticate(params[:password])
			sign_in user
			redirect_back_or user   # friendly forwarding or redirect to user page
		else
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
