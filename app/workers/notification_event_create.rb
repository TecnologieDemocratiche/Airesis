class NotificationEventCreate < NotificationSender
  #new events
  def perform(event_id)
    event = Event.find(event_id)
    user = event.user
    organizer = event.groups.first
    if organizer #if there is a group  #todo there are some problems with private and public events and their notifications (???)
      data = {event_id: event.id.to_s,
              group: organizer.name,
              group_id: organizer.id,
              user_id: user.id,
              event: event.title}
      data[:subdomain] = organizer.subdomain if organizer.certified?

      notification_a = Notification.create(notification_type_id: NotificationType::NEW_EVENTS, url: event_url(event), data: data)

      organizer.participants.each do |receiver|
        send_notification_to_user(notification_a, receiver) unless receiver == user #send an alert to everybody except the one which created the event
      end
    else
      data = {:event_id => event.id.to_s, :event => event.title, :user_id => user.id}
      notification_a = Notification.create(notification_type_id: NotificationType::NEW_PUBLIC_EVENTS, url: event_url(event), data: data)
      User.non_blocking_notification(NotificationType::NEW_PUBLIC_EVENTS).each do |receiver|
        send_notification_to_user(notification_a, user) unless receiver == user
      end
    end
  end
end
