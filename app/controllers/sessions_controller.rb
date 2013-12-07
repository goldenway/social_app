class SessionsController < ApplicationController
	def new
	end

	def create
		# when using "form_for" in app/views/sessions/new.html.erb use
		# params[:session][:email] and params[:session][:password]
		
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
