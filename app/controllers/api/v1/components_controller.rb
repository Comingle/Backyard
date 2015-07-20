require 'open3'

module Api
  module V1
class ComponentsController < V1Controller
  respond_to :json, :html
  before_action :set_component, only: [:show, :edit, :update, :destroy]

  # GET /components
  # GET /components.json
  def index
    respond_to do |format|
      format.html { @components = Component.all }
      format.json {
    @components = Hash[Component.pluck(:category).uniq.each_with_object(nil).to_a]
    @components.each do |k,v|
      @components[k] = Component.where("category = ?", k)
    end
    }
    end
    #respond_with @components
  end

  # GET /components/new
  def new
    @component = Component.new
  end

  # GET /components/1
  # GET /components/1.json
  def show
    if @components.present?
      respond_with @components
    else
      respond_with @component
    end
  end

  # GET /components/1/edit
  def edit
    @component = Component.find(params[:id])
    @vars = @component.variables
  end

  # POST /components
  # POST /components.json
  def create
    @component = Component.new(component_params)

    respond_to do |format|
      if @component.save
        format.html { redirect_to @component, notice: 'Component was successfully created.' }
        format.json { render :show, status: :created, location: @component }
      else
        format.html { render :new }
        format.json { render json: @component.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /components/1
  # PATCH/PUT /components/1.json
  def update
    respond_to do |format|
      if @component.update(component_params)
        format.html { redirect_to @component, notice: 'Component was successfully updated.' }
        format.json { render :show, status: :ok, location: @component }
      else
        format.html { render :edit }
        format.json { render json: @component.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /components/1
  # DELETE /components/1.json
  def destroy
    @component.destroy
    respond_to do |format|
      format.html { redirect_to components_url, notice: 'Component was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Returns available patterns. If params[:current], those are excluded
  # from the list.
  def patterns
    if params[:current_patterns]
      current_patterns = params[:current_patterns].split(",")
      @patterns = Component.patterns.where.not("name in (?)", current_patterns)
    else
      @patterns = Component.patterns
    end
    @options = Array.new
    @patterns.each do |p|
      @options.push(p.pat_options)
    end
    respond_with @patterns
  end

  def test_pattern
    if params[:settings]
      settings = JSON.parse(params[:settings])
      id = params[:id]
      @steps = Component.find(id).test_pattern(settings)
      respond_to do |format|
        format.json { render json: @steps }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_component
      if params[:id].match(/\D/)
        @component = Component.find_by_name(params[:id])
        if @component.blank?
          @components = Component.where("category = ?", params[:id])
          if @components.blank?
            raise ActiveRecord::RecordNotFound
          end
        end
      else
        @component = Component.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def component_params
      params[:component].values.each do |v|
        v.gsub! "\r", ""
      end
      params[:component].permit(:name,:category,:global,:setup,:loop,:period,:pretty_name,:description)
    end
end
end
end
