# також є такий хелпер в app/helpers/application_helper.rb

def full_title(page_title)
	base_title = "Social App"
	if page_title.empty?
		base_title
	else
		"#{base_title} | #{page_title}"
	end
end