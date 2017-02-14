class RequestsController < ApplicationController
  def index
    @requests = Request.all
    priority_modal = Request.priority_widget
    active_requests, max_length = Request.active_requests
    render locals: {
        priority_modal: priority_modal,
        active_requests: active_requests,
        max_length: max_length
    }
  end

  def new
    @request = Request.new
    #@data_file = @request.data_files.build
  end

  def create
    params.permit!
    @request = Request.new(request_params)

    @request.name = current_user.login


    if @request.save
      # Emails are placed Async.
      unless params[:dont_send_emails]
        Emailer.delay.new_request(@request.id)
      end
      save_data_files
      save_result_files if params[:result_files]
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
      unless params[:dont_send_emails]
        Emailer.delay.edit_request(@request.id)
      end
      save_data_files
      save_result_files
      redirect_to requests_path, notice: "The request #{@request.title} has been updated."
    else
      render 'edit'
    end
  end

  # Allowed params include nested attachments, results, and employee names. 
  private
  def request_params
    params.require(:request).permit(:name, :title, :description, :status, :stathist, :customer, :priority, :esthours, :tothours, {:assignment => []}, :result, data_files_attributes: [:id, :request_id, :attachment_uploader, :_destroy], result_files_attributes: [:id, :request_id, :attachment_uploader, :_destroy])
  end

  def save_data_files
    DataFile.where(:id => params["data_files_delete"]).destroy_all
    if params[:data_files]
      params[:data_files]['attachment_uploader'].each do |a|
        @data_file = @request.data_files.create!(:attachment_uploader => a, :request_id => @request.id)
      end
    end
  end

  def save_result_files
    DataFile.where(:id => params["result_files_delete"]).destroy_all
    if params[:result_files]
      params[:result_files]['attachment_uploader'].each do |a|
        @result_file = @request.result_files.create!(:attachment_uploader => a, :request_id => @request.id)
      end
    end
  end
end
