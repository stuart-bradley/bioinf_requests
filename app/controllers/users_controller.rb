class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if not params.has_key?(:min)
      params[:min] = (Date.today - 1.months)
    end

    if not params.has_key?(:max)
      params[:max] = Date.today
    end

    @requests = Request.select { |x| (x.assignment != nil || x.customer != nil) && x.name == current_user.login || x.customer == current_user.login || (x.get_users != nil && x.get_users.include?(current_user.login)) }
    @requests = @requests.select { |x| x.updated_at.to_date >= params[:min] && x.updated_at.to_date <= params[:max] }
    @manager = current_user
    @non_manager = User.select {|x| x.admin == true && (x.manager == false || x.manager == nil)}

    @analysis = current_user.manager_analytics(params[:min], params[:max])
    @user_metrics = current_user.user_analytics(@requests)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user]
    end
end
