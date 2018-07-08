class HashKey < ApplicationRecord
  belongs_to :user

  def self.verify(token)
    token = HashKey.where(token: token).last
    unless token.nil?
      if Time.now < token.expires_in
         true
       else
         false
      end
    end
  end
end
