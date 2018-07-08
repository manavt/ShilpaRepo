class Api::V2::UsersController < ApplicationController
  before_action :authenticate_user
  skip_before_action :authenticate_user, only: [:create, :sing_in]

  def index
    @user = User.last(4)
    respond_to do | format |
      unless @user.blank?
        format.html {} #look up for the page
        format.json { render json: {data: @user, status_code: 200} }
        format.xml {render xml: @user.as_json.to_xml}
      else
        format.html {} #look up for the page
        format.json { render json: {message: "No record found"} }
        format.xml {render xml: {message: "No data found"}}
      end
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      HashKey.create({token: generate_token(@user.email), expires_in: Time.now + 4.hours, user: @user})
      render json: {data: @user, status_code: 200, message: "Saved!"}
    else
      render json: {data: @user.errors, message: "Not saved!"}
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: {data: @user, status_code: 200, message: "Updated!"}
    else
      render json: {data: @user.errors, message: "Not updated!"}
    end
  end

  def destroy
    @user = User.find_by_id(params[:id])
    unless @user.nil?
      @user.delete
      render json: {message: "Deleted"}
    else
      render json: {message: "No record with id #{params[:id]}"}
    end
  end
  def sing_in
    @user = User.authenticate(params[:user][:email], params[:user][:password])
    if @user
      if Time.now < @user.hash_key.expires_in
        render json: {token: @user.hash_key.token, expires_in: @user.hash_key.expires_in}
      else
        token = generate_token(params[:email])
        @user.update({token: token, expires_in: Time.now + 4.hours})
        render json: {token: @user.hash_key.token, expires_in: @user.hash_key.expires_in}
      end
    else
      render json: {message: "Do the sign up first"}
    end
  end

  protected

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
  def generate_token(email)
     Digest::MD5.hexdigest(email + (1..10).to_a.sample.to_s)
  end
end

#{user: {name: some_value, email: some_value, password: some_value}}
