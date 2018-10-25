module ApplicationHelper
	def verbose_date(date)
		date.strftime('%B %d %Y')
	end

	def first_name
		@resource.name.split[0]
	end
end
