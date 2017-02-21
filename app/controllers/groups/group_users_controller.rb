class Groups::GroupUsersController < ApplicationController

  def index
    current_group = current_user.group
    authorize(current_group)

    @pending_group_users = current_group.group_users.includes(:user).pending

  end


  def approved
    current_group = current_user.group
    authorize(current_group, :view?)
    
    @group_user = GroupUser.find(params[:id])
    @group_user.approved!
  end

end
