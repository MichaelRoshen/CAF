class TeamsController < ApplicationController
  before_filter :require_user, :except => [:create]
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @teams = Team.all
    respond_with(@team)
  end

  def show
    respond_with(@team)
  end

  def new
    @team = Team.new
    respond_with(@team)
  end

  def edit
  end

  def create
    @team = Team.new(team_params)
    unless current_user.present?
      render :json => {:msg => '登录后才能创建球队！', :status => false} and return
    end
    if current_user.had_create_a_team?
      render :json => {:msg => '您已经创建过一支队伍了！', :status => false} and return
    end
    @team.creater_id = current_user.id
    @team.admins << current_user
    @team.save
    if @team.errors.present?
      render :json => {:msg => @team.errors[:name][0], :status => false}
    else
      render :json => {:msg => '', :status => true, :url => edit_team_path(@team)}
    end
  end

  def update
    @team.update(team_params)
    respond_with(@team)
  end 

  def destroy
    @team.destroy
    respond_with(@team)
  end

  private
    def set_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name,:coach, :qq,:captain, :mobile_phone, :territory, :bio, :culture, :honor, :company, :avatar,:location )
    end
end
