class EmailSendedJob < ApplicationJob
  queue_as :default

  def perform(object)
    event = object.event
    all_emails = event.subscriptions.map(&:user_email) + [event.user.email] - [object.user&.email]

    case object
    when Subscription
      EventMailer.subscription(object).deliver_later
    when Comment
      all_emails.each do |email|
        EventMailer.comment(object, email).deliver_later
      end
    when Photo
      all_emails.each do |email|
        EventMailer.photo(object, email).deliver_later
      end
    end
  end
end
