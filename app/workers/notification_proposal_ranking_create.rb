class NotificationProposalRankingCreate < NotificationSender

  #send alerts when there is a new valuatation for the proposal #todo test
  def perform(proposal_ranking_id)
    proposal_ranking = ProposalRanking.find(proposal_ranking_id)
    proposal = proposal_ranking.proposal
    group = proposal.groups.first if proposal.in_group?

    data = {proposal_id: proposal.id.to_s, title: proposal.title}
    notification_a = Notification.create(notification_type_id: NotificationType::NEW_VALUTATION_MINE, url: url_for_proposal(proposal, group), data: data)
    proposal.users.each do |user|
      send_notification_for_proposal(notification_a, user, proposal) if user != proposal_ranking.user
    end
    notification_b = Notification.create(notification_type_id: NotificationType::NEW_VALUTATION, url: url_for_proposal(proposal, group), data: data)
    proposal.participants.each do |user|
      if (user != proposal_ranking.user) && (!proposal.users.include? user)
        send_notification_for_proposal(notification_b, user, proposal)
      end
    end
  end
end
