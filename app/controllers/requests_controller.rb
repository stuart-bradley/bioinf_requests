class RequestsController < ApplicationController
  def index
  	@requests = Request.all
    @user_nil = User.where(:id => 39).first
  end

  def new
  	@request = Request.new
    #@data_file = @request.data_files.build
  end

  def create
    params.permit!
  	@request = Request.new(request_params)

    if ! current_user.nil?
      @request.name = current_user.login
    else
      @request.name = 'nil'
    end
    
  	if @request.save
  	  # Emails are placed Async.
      if !(params[:email_check])
        Emailer.delay.new_request(@request.id)
      end
      if params[:data_files]
      	# Attachments are created from the nested attributes.
        params[:data_files]['attachment_uploader'].each do |a|
          @data_file = @request.data_files.create!(:attachment_uploader => a, :request_id => @request.id)
        end
      end 
      if params[:result_files]
        params[:result_files]['attachment_uploader'].each do |a|
          @result_file = @request.result_files.create!(:attachment_uploader => a, :request_id => @request.id)
        end
      end
  		redirect_to requests_path, notice: "The request #{@request.title} has been uploaded."
  	else
  		render "new"
  	end
  end

  def destroy
  	@request = Request.find(params[:id])
  	@request.destroy
  	redirect_to requests_path, notice: "The request #{@request.title} has been deleted."
  end

  def edit
    @request = Request.find(params[:id])
  end

  def update
    params.permit!
    @request = Request.find(params[:id])
    if @request.update_attributes(request_params)
      # The email send logic is contained within each edit type, as to 
      # avoid sending emails where no changes have occured. 
      if !(params[:email_check])
        Emailer.delay.edit_request(@request.id)
      end
      if params[:data_files]
        params[:data_files]['attachment_uploader'].each do |a|
          @data_file = @request.data_files.create!(:attachment_uploader => a, :request_id => @request.id)
        end
      end 
      if params[:result_files]
        params[:result_files]['attachment_uploader'].each do |a|
          @result_file = @request.result_files.create!(:attachment_uploader => a, :request_id => @request.id)
        end
      end
      redirect_to requests_path, notice: "The request #{@request.title} has been updated."
    else
      render 'edit'
    end
  end

  # Allowed params include nested attachments, results, and employee names. 
  private 
    def request_params
      params.require(:request).permit(:name, :title,:description, :status, :stathist, :customer, {:assignment =>[]}, :result, data_files_attributes: [:id, :request_id, :attachment_uploader], result_files_attributes: [:id, :request_id, :attachment_uploader], employee_attributes: [:id, :request_id, :name, :email])
    end
end
