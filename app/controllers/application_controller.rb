class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: Proc.new {|r|  r.request.format.json? or  r.request.format.xml?}

  def authenticate_user
    token = params[:token]
    unless token.nil?
      unless HashKey.verify(token)
          return render json: {message: "Not a valid token, do signin/signup"}
      end
    else
        return render json: {message: "missing token"}
    end
  end

  before_action :web_auth
  def web_auth
    if session[:user_id].blank?
      redirect_to make_session_users_path
    end
  end
  # before_action :server_from_cache
  # def server_from_cache
  #   if File.exists?("#{Rails.root.to_s}/public/cache/#{params[:action]}.html")
  #     #render file: "public/cache/#{params[:action]}.html"
  #     expire_page action: 'index'
  #   end
  # end
end
