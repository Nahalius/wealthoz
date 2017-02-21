class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
    @projects = Project.count
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @group = @user.group(params[:name])
    @projects = @group.projects(params[:name])
    @current_group = @group.users.select(:name)
  end


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.group = Group.where(name: 'Pool').first
    if @user.save
      flash[:success] = "Welcome to WealthOZ. Sign in to use the system !!!"
      redirect_to @user
    else
      render 'new'
    end
  end


  def edit
    @user = User.find(params[:id])

  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation,:group_id)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end


  def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation,:group_id)
    end

    def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end


    # Before filters
    def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

end
