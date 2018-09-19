class ProjectsController < ApplicationController
	before_action :set_project, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, only: [:edit, :update, :destroy]

	def index
		@projects = Project.all.order("created_at DESC")
	end

	def show
	end

	def new
		@project = current_user.projects.build 
		@teams = Team.where('id = ?, current_user.team_id')
	end

	def edit 
		@teams = current_user.teams 
	end

	def create
		@project = current_user.projects.build(project_params)

		respond_to do |format|
			if @project.save
				format.html { redirect_to @project, notice: 'Project was created successfully 🤠'}
				format.json { render :show, status: :created, location: @project }
			else 
				format.html { render :new }
				format.json { render json: @project.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @project.update(project_params)
				format.html { redirect_to @project, notice: 'Project was updated successfully 😩👌'}
				format.json { render :show, status: :ok, location: @project }
			else 
				format.html { render :edit }
				format.json { render json: @project.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy 
		@project.destroy 
		respond_to do |format|
			format.html { redirect_to root_path, notice: 'Project was removed successfully 😔 {{sad yeehaw}}'}
			format.json { head :no_content }
		end
	end

	private 

	def set_project
		@project = Project.find(params[:id])
	end

	def project_params
		params.require(:project).permit(:name, :description, :team_id)
	end
end