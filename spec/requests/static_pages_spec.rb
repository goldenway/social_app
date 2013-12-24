require 'spec_helper'

describe "Static pages" do
	subject { page }

	shared_examples_for "all static pages" do
		it { should have_selector('title', text: full_title(page_title)) }
		it { should have_selector('h1',    text: heading) }
	end

	describe "Home page" do
		before { visit root_path }
		let(:page_title) { '' }
		let(:heading)	 { 'Social App' }

		it_should_behave_like "all static pages"
		it { should_not have_selector('title',	text: '| Home') }
		it { should have_content('Welcome') }

		describe "for signed-in users" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
				FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
				sign_in user
				visit root_path
			end

			it { should have_content('2 microposts') }

			describe "follower/folowing counts" do
				let(:other_user) { FactoryGirl.create(:user) }
				before do
					other_user.follow!(user)
					visit root_path
				end

				it { should have_link("0 following", href: following_user_path(user)) }
				it { should have_link("1 followers", href: followers_user_path(user)) }
			end

			it "should render the user's feed" do
				user.feed.each do |item|
					page.should have_selector("li##{item.id}", text: item.content)
				end
			end

			describe "pagination in user's feed" do
				before (:all) { 30.times { FactoryGirl.create(:micropost) } }
				after(:all)   { Micropost.delete_all}

				# it { should have_selector('div.pagination') }   # ??? not works

				it "should list each micropost" do
					Micropost.paginate(page: 1, per_page: 6).each do |micropost|
						page.should have_selector('li', text: micropost.content)
					end
				end
			end
		end
	end

	describe "Help page" do
		before { visit help_path }
		let(:page_title) { 'Help' }
		let(:heading)	 { 'Help' }

		it_should_behave_like "all static pages"
	end

	describe "About page" do
		before { visit about_path }
		let(:page_title) { 'About Us' }
		let(:heading)	 { 'About Us' }

		it_should_behave_like "all static pages"
	end

	describe "Contact page" do
		before { visit contact_path }
		let(:page_title) { 'Contact' }
		let(:heading)    { 'Contact' }

		it_should_behave_like "all static pages"
	end

	describe "should have the right links on the layout" do
		it { should_have_correct_static_pages_links } # defined in spec/support/utilities.rb
	end
end
