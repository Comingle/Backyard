class SketchHistoriesController < ApplicationController
  before_action :set_sketch_history, only: [:show, :edit, :update, :destroy]

  # GET /sketch_histories
  # GET /sketch_histories.json
  def index
    @sketch_histories = SketchHistory.all
  end

  # GET /sketch_histories/1
  # GET /sketch_histories/1.json
  def show
  end

  # GET /sketch_histories/new
  def new
    @sketch_history = SketchHistory.new
  end

  # GET /sketch_histories/1/edit
  def edit
  end

  # POST /sketch_histories
  # POST /sketch_histories.json
  def create
    @sketch_history = SketchHistory.new(sketch_history_params)

    respond_to do |format|
      if @sketch_history.save
        format.html { redirect_to @sketch_history, notice: 'Sketch history was successfully created.' }
        format.json { render :show, status: :created, location: @sketch_history }
      else
        format.html { render :new }
        format.json { render json: @sketch_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sketch_histories/1
  # PATCH/PUT /sketch_histories/1.json
  def update
    respond_to do |format|
      if @sketch_history.update(sketch_history_params)
        format.html { redirect_to @sketch_history, notice: 'Sketch history was successfully updated.' }
        format.json { render :show, status: :ok, location: @sketch_history }
      else
        format.html { render :edit }
        format.json { render json: @sketch_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sketch_histories/1
  # DELETE /sketch_histories/1.json
  def destroy
    @sketch_history.destroy
    respond_to do |format|
      format.html { redirect_to sketch_histories_url, notice: 'Sketch history was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sketch_history
      @sketch_history = SketchHistory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sketch_history_params
      params[:sketch_history]
    end
end
