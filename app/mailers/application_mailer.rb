# Shared helpers available to mailers
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
