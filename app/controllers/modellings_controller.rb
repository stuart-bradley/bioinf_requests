# encoding: utf-8

class ModellingsController < ApplicationController
  before_action :set_modelling, only: [:show, :edit, :update, :destroy]

  # GET /modellings
  # GET /modellings.json
  def index
    @modellings = Modelling.all
  end

  # GET /modellings/1
  # GET /modellings/1.json
  def show
  end

  # GET /modellings/new
  def new
    #@modelling = Modelling.new
    redirect_to "http://192.168.46.146/modelling/request.php​"
    Emailer.new_model_request.deliver
  end

  # GET /modellings/1/edit
  def edit
  end

  # POST /modellings
  # POST /modellings.json
  def create
    @modelling = Modelling.new(modelling_params)

    respond_to do |format|
      if @modelling.save
        format.html { redirect_to @modelling, notice: 'Modelling was successfully created.' }
        format.json { render action: 'show', status: :created, location: @modelling }
      else
        format.html { render action: 'new' }
        format.json { render json: @modelling.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /modellings/1
  # PATCH/PUT /modellings/1.json
  def update
    respond_to do |format|
      if @modelling.update(modelling_params)
        format.html { redirect_to @modelling, notice: 'Modelling was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @modelling.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /modellings/1
  # DELETE /modellings/1.json
  def destroy
    @modelling.destroy
    respond_to do |format|
      format.html { redirect_to modellings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modelling
      @modelling = Modelling.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def modelling_params
      params[:modelling]
    end
end
