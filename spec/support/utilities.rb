include ApplicationHelper

# methods for static pages spec

def should_have_correct_static_pages_links
	visit root_path
	click_link "About"
	page.should have_selector 'title', text: full_title('About Us')
	click_link "Help"
	page.should have_selector 'title', text: full_title('Help')
	click_link "Contact"
	page.should have_selector 'title', text: full_title('Contact')
	click_link "Home"
	click_link "Sign up now!"
	page.should have_selector 'title', text: full_title('Sign up')
	click_link "social app"
	page.should have_selector 'title', text: 'Social App'
end

# methods for authentication pages spec

def sign_in(user)
	visit signin_path
	fill_in "Email",    with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"

	# filling in the form doesn’t work when not using Capybara
	cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-error', text: message)
	end
end



