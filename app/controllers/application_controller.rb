class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error_response



  

  def not_found_error_response(error)
    error_object = Error.new(error.message, "404")
    render json: ErrorSerializer.serialize_error(error_object), status: error_object.status_code
  end
end
