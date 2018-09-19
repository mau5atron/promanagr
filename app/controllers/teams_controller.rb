class TeamsController < ApplicationController
	before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy]

  def index
    @teams = Team.all.order("created_at DESC")
  end

  def show
  end

  def new
    @team = current_user.teams.build
    @user = current_user
  end

  def edit
  end
  
  def create
    @team = current_user.teams.build(team_params)
    @team.users.push current_user

    respond_to do |format|
      if @team.save
        format.html { redirect_to root_path, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, users_attributes: [:id, :name, :email, :_destroy])
  end
end