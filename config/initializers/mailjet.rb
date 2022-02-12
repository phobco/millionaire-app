Mailjet.configure do |config|
  config.api_key = Rails.application.credentials.dig(:mail, :mailjet_api_key)
  config.secret_key = Rails.application.credentials.dig(:mail, :mailjet_secret_key)
  config.api_version = 'v3.1'
end
