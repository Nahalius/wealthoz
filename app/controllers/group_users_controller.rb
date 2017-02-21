class GroupUsersController < ApplicationController

  def edit
    @group_user = current_user.group_user
    render 'edit'
  end

  def update
    @group_user = current_user.group_user
    @group_user.update(group_user_params)
    @group_user.pending!
    redirect_to edit_user_path(current_user), notice: "Wealth Group changed to #{@current_user.group}. Status pending"
  end

  private

  def group_user_params
    params.require(:group_user).permit(group_user_attrs)
  end

  def group_user_attrs
    [ :group_id ]
  end

end
