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

# methods for user pages spec

def fill_in_form_with_valid_information
	fill_in "Name", 		with: "Example User"
	fill_in "Email",		with: "user@example.com"
	fill_in "Password",		with: "foobar"
	fill_in "Confirmation",	with: "foobar"
end

# methods for authentication pages spec

def valid_signin(user)
	fill_in "Email",    with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-error', text: message)
	end
end



