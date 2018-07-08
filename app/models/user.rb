class User < ApplicationRecord
  has_one :hash_key, dependent: :destroy

  def self.authenticate(email, password)
    @user = User.where(email: email, password: password).last
    if @user
      @user
    else
      nil
    end
  end
  def self.authenticate_from_web(em, pwd)
    @user = User.where(email: em, password: pwd).last
  end

  def self.omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.token = auth.credentials.token
      user.email = auth.info.email
      user.expires_at = Time.at(auth.credentials.expires_at)
      user.save(validate: false)
      user
    end
  end
end
