class NunchucksController < ApplicationController
  before_action :set_nunchuck, only: [:show, :edit, :update, :destroy]

  # GET /nunchucks
  # GET /nunchucks.json
  def index
    @nunchucks = Nunchuck.all
  end

  # GET /nunchucks/1
  # GET /nunchucks/1.json
  def show
  end

  # GET /nunchucks/new
  def new
    @nunchuck = Nunchuck.new
  end

  # GET /nunchucks/1/edit
  def edit
  end

  # POST /nunchucks
  # POST /nunchucks.json
  def create
    @nunchuck = Nunchuck.new(nunchuck_params)

    respond_to do |format|
      if @nunchuck.save
        format.html { redirect_to @nunchuck, notice: 'Nunchuck was successfully created.' }
        format.json { render :show, status: :created, location: @nunchuck }
      else
        format.html { render :new }
        format.json { render json: @nunchuck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nunchucks/1
  # PATCH/PUT /nunchucks/1.json
  def update
    respond_to do |format|
      if @nunchuck.update(nunchuck_params)
        format.html { redirect_to @nunchuck, notice: 'Nunchuck was successfully updated.' }
        format.json { render :show, status: :ok, location: @nunchuck }
      else
        format.html { render :edit }
        format.json { render json: @nunchuck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nunchucks/1
  # DELETE /nunchucks/1.json
  def destroy
    @nunchuck.destroy
    respond_to do |format|
      format.html { redirect_to nunchucks_url, notice: 'Nunchuck was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_nunchuck
      @nunchuck = Nunchuck.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def nunchuck_params
      params[:nunchuck]
    end
end
