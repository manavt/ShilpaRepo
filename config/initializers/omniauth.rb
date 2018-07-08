OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '773218582714243', 'b6543372ab49585059dd405cb43ad9ac'
end
