class Project < ApplicationRecord
	belongs_to :team
	belongs_to :user

	#ability to assign a project to a team by default / requires user to select the team that a given project is for 
	accept_nested_attributes_for :team
end