class WorkoutsController < ApplicationController
  # GET /workouts
  # GET /workouts.json
  def index
    @workouts = current_user.workouts.order("id DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @workouts }
    end
  end

  # GET /workouts/1
  # GET /workouts/1.json
  def show
    @workout = current_user.workouts.find(params[:id])
    
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @workout }
    end
  end

  # GET /workouts/new
  # GET /workouts/new.json
  def new
    redirect_to workout_path(Workout.generate(current_user))
  end

  # GET /workouts/1/edit
  def edit
    @workout = current_user.workouts.find(params[:id])
  end

  # POST /workouts
  # POST /workouts.json
  def create
    @workout = current_user.workouts.new(params[:workout])

    respond_to do |format|
      if @workout.save
        format.html { redirect_to @workout, notice: 'Workout was successfully created.' }
        format.json { render json: @workout, status: :created, location: @workout }
      else
        format.html { render action: "new" }
        format.json { render json: @workout.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /workouts/1
  # PUT /workouts/1.json
  def update
    @workout = current_user.workouts.find(params[:id])
    
    respond_to do |format|
      if @workout.update_attributes(params[:workout])
        @workout.workout_units.each { |wu| wu.set_recommendation }
        
        @workout.update_attribute(:submitted, true)
        @workout.workout_units.each { |wu| wu.update_attribute(:submitted, true) }
        
        format.html { redirect_to @workout, notice: 'Workout was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @workout.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workouts/1
  # DELETE /workouts/1.json
  def destroy
    @workout = current_user.workouts.find(params[:id])
    @workout.destroy

    respond_to do |format|
      format.html { redirect_to workouts_url }
      format.json { head :no_content }
    end
  end
end
