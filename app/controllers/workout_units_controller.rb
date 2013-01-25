class WorkoutUnitsController < ApplicationController
  # GET /workout_units
  # GET /workout_units.json
  def index
    @workout_units = WorkoutUnit.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @workout_units }
    end
  end

  # GET /workout_units/1
  # GET /workout_units/1.json
  def show
    @workout_unit = WorkoutUnit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @workout_unit }
    end
  end

  # GET /workout_units/new
  # GET /workout_units/new.json
  def new
    @workout_unit = WorkoutUnit.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @workout_unit }
    end
  end

  # GET /workout_units/1/edit
  def edit
    @workout_unit = WorkoutUnit.find(params[:id])
  end

  # POST /workout_units
  # POST /workout_units.json
  def create
    @workout_unit = WorkoutUnit.new(params[:workout_unit])

    respond_to do |format|
      if @workout_unit.save
        format.html { redirect_to @workout_unit, notice: 'Workout unit was successfully created.' }
        format.json { render json: @workout_unit, status: :created, location: @workout_unit }
      else
        format.html { render action: "new" }
        format.json { render json: @workout_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /workout_units/1
  # PUT /workout_units/1.json
  def update
    @workout_unit = WorkoutUnit.find(params[:id])

    respond_to do |format|
      if @workout_unit.update_attributes(params[:workout_unit])
        format.html { redirect_to @workout_unit, notice: 'Workout unit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @workout_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workout_units/1
  # DELETE /workout_units/1.json
  def destroy
    @workout_unit = WorkoutUnit.find(params[:id])
    @workout_unit.destroy

    respond_to do |format|
      format.html { redirect_to workout_units_url }
      format.json { head :no_content }
    end
  end
end
