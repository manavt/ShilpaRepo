class UsersController < ApplicationController
   #before_action :authenticate_user

  # skip_before_action :authenticate_user, only: [:create, :sing_in]
  skip_before_action :web_auth, only: [:create, :make_session, :new, :auth_sing_in, :facebook]
  include PrintMyName

  def index
    @user = User.all
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

  def new
    @user = User.new
  end
  def logout
    session[:user_id] = nil
    redirect_to make_session_users_path
  end
  def auth_sing_in
     @user = User.authenticate_from_web(params[:email], params[:password])
     if @user.nil?
       redirect_to make_session_users_path
     else
       session[:user_id]  = @user.id
       redirect_to users_path
     end
  end

  def facebook
    user = User.omniauth(request.env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to users_path
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        HashKey.create({token: generate_token(@user.email), expires_in: Time.now + 4.hours, user: @user})
        UserMailer.welcome(@user).deliver_now!
        format.html { redirect_to users_path}
        format.json {render json: {data: @user, status_code: 200, message: "Saved!"} }
      else
        format.json { render json: {data: @user.errors, message: "Not saved!"} }
      end
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
      @user.destroy
      render json: {message: "Deleted", my_name: my_name}
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

  def make_payment
    #product price , cc number, cc exiry date, ccv
    current_user=User.find(session[:user_id])
    # @product=Product.find(params[:id])
    @result = Braintree::Transaction.sale(
    :amount => "100.00",
    :credit_card => {
      :number => "4500600000000061",
      :expiration_date => "07/2023"
    },
    :options=> {
                    store_in_vault: true
                  })
    if @result.success?
      current_user.update(braintree_customer_id: @result.transaction.customer_details.id)
      redirect_to users_path, notice: "Congraulations! Your transaction has been successfully!"
    else
      redirect_to chats_path, notice: "Transaction fail"
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
