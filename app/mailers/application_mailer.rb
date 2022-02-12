class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:mail, :default_mail)
  layout 'mailer'
end
