class AdminController < ApplicationController
  before_filter :redirect_unless_admin, :except => [:login]

  def login
    if request.post?
      if params[:password] == 'repper4evver'
        flash[:success] = "valid"
        session[:admin] = true
        redirect_to :action => "index"
      else
        flash[:error] = "invalid"
        redirect_to root_url
      end    
    end
  end
  
  def index
  end
  
  def logout
    session[:admin] = false
    session[:success] = "Logged out of admin status"
    redirect_to root_url
  end
  
end