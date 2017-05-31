class RequestDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :link_to, :button_to, :edit_request_path, :request_path
  def_delegators :@view, :sanatize_wysihtml, :truncate, :raw, :simple_format, :current_user

  def view_columns
    @view_columns ||= {
        id: {source: "Request.id", cond: :eq},
        title: {source: "Request.title"},
        submitted_by: {source: "Request.submitted_by"},
        description: {source: "Request.description"},
        download_attachment: {source: "Request.download_attachment"},
        results: {source: "Request.results"},
        result_files: {source: "Request.result_files"},
        status: {source: "Request.status"},
        status_history: {source: "Request.status_history"},
        priority: {source: "Request.priority"},
        job_assignment: {source: "Request.job_assignment"},
        buttons: {source: "Request.buttons"}
    }
  end

  def data
    records.map do |record|
      {
          id: record.id,
          title: record.title,
          submitted_by: data_tables_get_name(record),
          description: sanatize_wysihtml(record.description),
          download_attachment: data_tables_files(record.data_files),
          results: sanatize_wysihtml(record.result),
          result_files: data_tables_files(record.result_files),
          status: record.status,
          status_history: simple_format(record.stathist),
          priority: record.priority,
          job_assignment: record.get_users_for_view,
          buttons: data_tables_buttons(record)
      }
    end
  end

  private

  def get_raw_records
    Request.includes(:data_files, :result_files).order('id desc').load
  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
  def data_tables_get_name(record)
    result = record.get_name
    if record.customer?
      result += "<br/> (" + User.where(:login => record.customer).first.get_name + ")"
    end
    return raw result
  end

  def data_tables_files(record_files)
    result = ""
    record_files.each do |p|
      result += (link_to truncate("#{p.attachment_uploader_url.split("/").last}", :length => 20), p.attachment_uploader_url, {:title => "#{p.attachment_uploader_url.split("/").last}"})
      result += "<br/>"
    end
    return raw result
  end

  def data_tables_buttons(record)
    result = ""
    if record.name == current_user.login || current_user.admin
      result += (link_to "Edit", edit_request_path(record), class: "btn btn-default")
      result += (button_to "Delete", request_path(record), method: :delete, class: "btn btn-default", data: {confirm: "Are you sure that you wish to delete #{record.title}?"})
    end
    return raw result
  end
end
