class PerodizationsController < ApplicationController
  # GET /perodizations
  # GET /perodizations.json
  def index
    @perodizations = Perodization.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @perodizations }
    end
  end

  # GET /perodizations/1
  # GET /perodizations/1.json
  def show
    @perodization = Perodization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @perodization }
    end
  end

  # GET /perodizations/new
  # GET /perodizations/new.json
  def new
    @perodization = Perodization.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @perodization }
    end
  end

  # GET /perodizations/1/edit
  def edit
    @perodization = Perodization.find(params[:id])
  end

  # POST /perodizations
  # POST /perodizations.json
  def create
    @perodization = Perodization.new(params[:perodization])

    respond_to do |format|
      if @perodization.save
        format.html { redirect_to @perodization, notice: 'Perodization was successfully created.' }
        format.json { render json: @perodization, status: :created, location: @perodization }
      else
        format.html { render action: "new" }
        format.json { render json: @perodization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /perodizations/1
  # PUT /perodizations/1.json
  def update
    @perodization = Perodization.find(params[:id])

    respond_to do |format|
      if @perodization.update_attributes(params[:perodization])
        format.html { redirect_to @perodization, notice: 'Perodization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @perodization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /perodizations/1
  # DELETE /perodizations/1.json
  def destroy
    @perodization = Perodization.find(params[:id])
    @perodization.destroy

    respond_to do |format|
      format.html { redirect_to perodizations_url }
      format.json { head :no_content }
    end
  end
end
