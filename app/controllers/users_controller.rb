class UsersController < ApplicationController
  
  def waiver  
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.welcome_email(@user).deliver
      login(params[:user][:email], params[:user][:password])
      redirect_to signup_complete_url, :notice => "Welcome!"
    else
      render :new
    end
  end
  
  def show
    @user = User.find(current_user)
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = User.find(current_user)    
    
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
    
  end

end
