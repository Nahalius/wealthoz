class SessionsController < ApplicationController


  def new
    render 'new'
  end

  def create

    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      if current_user.group.name != "Pool"
        redirect_to root_url
      else
        redirect_back_or new_group_path
      end
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end



  def destroy
    sign_out
    redirect_to root_url

  end

end
