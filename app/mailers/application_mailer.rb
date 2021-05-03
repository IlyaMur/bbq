class ApplicationMailer < ActionMailer::Base
  default from: "BBQ PARTY #{ENV['MAILJET_SENDER']}"
  layout 'mailer'
end
