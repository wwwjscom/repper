class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Signed up!"
    else
      render :new
    end
  end
  
  def show
    @user = User.find(current_user)
  end
  
  def edit
    @user = current_user
    @muscle_groups = @user.muscle_group_ids
  end
  
  def update
    @user = User.find(current_user)
    params[:user][:muscle_group_ids] ||= []
   active_groups = params[:user][:muscle_group_ids]
   

    params[:user][:muscle_group_ids] = []
    
    
    if @user.update_attributes(params[:user])      
      # Reset old muscle groups
      @user.muscle_groups = []

      # Setup new muscle groups
      active_groups.each do |id, checked|
        @user.muscle_groups << MuscleGroup.find_by_name(id) if checked == "1"      
      end
      @user.save
      
      redirect_to @user, notice: 'User was successfully updated.'
    else
      format.html { render action: "edit" }
    end
    
  end

end
