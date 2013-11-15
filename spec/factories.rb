FactoryGirl.define do
	factory :user do
		name		"Igor M"
		email		"user@example.com"
		password	"foobar"
		password_confirmation "foobar"
	end
end