module Frm
  class Subscription < FrmTable
    belongs_to :topic
    belongs_to :subscriber, class_name: 'User'

    validates :subscriber_id, presence: true

    def send_notification(post_id)
      # If a user cannot be found, then no-op
      # This will happen if the user record has been deleted.
      if subscriber.present?
        ResqueMailer.delay.topic_reply(post_id, subscriber.id)
      end
    end
  end
end
