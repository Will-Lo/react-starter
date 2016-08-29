class ApplicationController < ActionController::API

  include ActionController::RequestForgeryProtection
  include ::ActionController::Serialization
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  before_action :add_allow_credentials_headers

  # defines which headers are allowed to be passed through a request
  def add_allow_credentials_headers
    response.headers['Access-Control-Allow-Origin'] = request.headers['Origin'] ||'*'
    response.headers['Access-Control-Allow-Credentials'] = 'true'
    response.headers['Access-Control-Allow-Methods'] = "GET", "PUT", "PATCH", "POST", "DELETE", "OPTIONS"
  end

  def options
    head :status => 200, :'Access-Control-Allow-Headers' =>
    'accept, content-type, Authorization, cache-control, x-requested-with'
  end

  # used within every controller in the backend
  # allows the methods to render JSON of the response given from the server
  def response_data(message, data, status)
    render json: { :status => status, :message => message, :data => data}, :status => status
  end
end
