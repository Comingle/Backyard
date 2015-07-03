require 'digest'
require 'open3'

module Api
  module V1
class SketchesController < ApplicationController
  respond_to :json
  before_action :set_sketch, only: [:show, :edit, :update, :destroy]

  rescue_from Sketch::BuildError, :with => :build_error

  def build_error(exception)
    flash[:notice] = "There was an error building your sketch: #{exception.message}"
    # Event.new_event "Exception: #{exception.message}"
    redirect_to url_for([:edit, @sketch])
  end

  # GET /sketches
  # GET /sketches.json
  def index
    @sketches = Sketch.all
    respond_with @sketches
  end

  # GET /sketches/1
  # GET /sketches/1.json
  def show
    #respond_to do |format|
    #  format.json { render :show, status: :created, location: @sketch}
    #  format.html { render :show, status: :created, location: @sketch}
    #end
    respond_with @sketch
  end

  # POST /sketches/find
  def find
    @sketch = Sketch.find_by_hex(params[:sketch])
  end

  # GET /sketches/new
  #def new
  #  @sketch = Sketch.new
  #  @patterns = Component.select(:id, :name, :pretty_name, :description, :category).where(:category => "pattern")
  #end

  # GET /sketches/1/edit
  def edit
    @patterns = @sketch.patterns
    @pattern_options = @patterns.inject(Array.new) { |result, element|
      result.push(element.options_with_values)
    }
  end

  # POST /sketches
  # POST /sketches.json
  def create
    @sketch = Sketch.new(sketch_params)
    @sketch.config= JSON.parse(sketch_params["config"])
    build_props = @sketch.build_sketch
    puts build_props
    dupe = Sketch.find_by_size_and_sha256(build_props[:size], build_props[:sha256])
    if dupe
      @sketch = dupe
    else
      @sketch.save!
      @sketch
    end
  end

  # PATCH/PUT /sketches/1
  # PATCH/PUT /sketches/1.json
  #def update
  #  respond_to do |format|
  #    if @sketch.update(sketch_params)
  #      format.html { redirect_to @sketch, notice: 'Sketch was successfully updated.' }
  #      format.json { render :show, status: :ok, location: @sketch }
  #    else
  #      format.html { render :edit }
  #      format.json { render json: @sketch.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /sketches/1
  # DELETE /sketches/1.json
  def destroy
    @sketch.destroy
    respond_to do |format|
      format.html { redirect_to sketches_url, notice: 'Sketch was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def missing
    puts params
      current_patterns = params[:current_patterns].split(',')
      # current_patterns = @sketch.components.pluck(:name)
    Component.patterns.where.not("name in (?)", current_patterns).each do |c|
      puts c.name
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sketch
      if params[:id].match(/\D/)
        @sketch = Sketch.find_by_sha256(params[:id])
      else
        @sketch = Sketch.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sketch_params
      params[:sketch].permit(:click, :doubleclick, :longpressstart, :serial_console, :startup_sequence, :model, :config)
    end

    def get_token
      date = Time.now.strftime("%Y-%m-%d")
      token = "#{date}-" + SecureRandom.hex(6)
    token
  end
end
end
end
