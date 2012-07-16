class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    if request.env["HTTP_REFERER"].blank?
      redirect_to root_url, :alert => exception.message
    else
      redirect_to :back, :alert => exception.message
    end
  end
end
