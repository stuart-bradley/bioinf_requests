class RequestsController < ApplicationController
  def index
    @requests = Request.includes(:data_files, :result_files).load
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

      DataFile.save_data_files(params[:data_files], params["data_files_delete"], @request)
      ResultFile.save_result_files(params[:result_files], params["result_files_delete"], @request)

      redirect_to requests_path, notice: "The request #{@request.title} has been created."
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
        @request.send_edit_email
      end
      DataFile.save_data_files(params[:data_files], params["data_files_delete"], @request)
      ResultFile.save_result_files(params[:result_files], params["result_files_delete"], @request)

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
end
