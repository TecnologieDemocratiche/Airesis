class GroupInvitation < ActiveRecord::Base

  has_many :group_invitation_emails
  belongs_to :inviter, class_name: 'User', foreign_key: :inviter_id
  belongs_to :group

  before_create :build_data

  attr_accessor :emails_list

  protected

  def build_data
    email_array = emails_list.split ","

    email_array.each do |email|
      # check that the user didn't block invitation emails
      # check that he has not been already invited
      # check that he is not already part of the group
      unless BannedEmail.find_by(email: email) || group.group_invitation_emails.find_by(email: email) || group.participants.find_by(email: email)
        group_invitation_emails.build(email: email)
      end
    end
  end
end
