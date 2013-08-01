class ProgressionEventLogsController < ApplicationController
  # GET /progression_event_logs
  # GET /progression_event_logs.json
  def index
    @progression_event_logs = current_user.progression_event_logs.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @progression_event_logs }
    end
  end

  # GET /progression_event_logs/1
  # GET /progression_event_logs/1.json
  def show
    @progression_event_log = current_user.progression_event_logs.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @progression_event_log }
    end
  end

  # GET /progression_event_logs/new
  # GET /progression_event_logs/new.json
  def new
    @progression_event_log = current_user.progression_event_logs.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @progression_event_log }
    end
  end

  # GET /progression_event_logs/1/edit
  def edit
    @progression_event_log = current_user.progression_event_logs.find(params[:id])
  end

  # POST /progression_event_logs
  # POST /progression_event_logs.json
  def create
    @progression_event_log = current_user.progression_event_logs.new(params[:progression_event_log])

    respond_to do |format|
      if @progression_event_log.save
        format.html { redirect_to @progression_event_log, notice: 'Progression event log was successfully created.' }
        format.json { render json: @progression_event_log, status: :created, location: @progression_event_log }
      else
        format.html { render action: "new" }
        format.json { render json: @progression_event_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /progression_event_logs/1
  # PUT /progression_event_logs/1.json
  def update
    @progression_event_log = current_user.progression_event_logs.find(params[:id])

    respond_to do |format|
      if @progression_event_log.update_attributes(params[:progression_event_log])
        format.html { redirect_to @progression_event_log, notice: 'Progression event log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @progression_event_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /progression_event_logs/1
  # DELETE /progression_event_logs/1.json
  def destroy
    @progression_event_log = current_user.progression_event_logs.find(params[:id])
    @progression_event_log.destroy

    respond_to do |format|
      format.html { redirect_to progression_event_logs_url }
      format.json { head :no_content }
    end
  end
end
