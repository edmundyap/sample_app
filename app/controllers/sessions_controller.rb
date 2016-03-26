class SessionsController < ApplicationController
  
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        if user.activated?
    	   log_in user
         params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    	   redirect_back_or user
        else
         #flash.now because render is not counted as a request. Without it, the flash will persist until the next request.
         message = "Account not activated."
         message += "Check your email for the activation link."
         flash[:warning] = message
         redirect_to root_url
        end
    else
      flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
  	log_out if logged_in?
  	redirect_to root_url
  end
end
