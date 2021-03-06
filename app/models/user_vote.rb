class UserVote < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :proposal, class_name: 'Proposal', foreign_key: :proposal_id
  belongs_to :vote_type, class_name: 'VoteType', foreign_key: :vote_type_id
  validates :user_id, uniqueness: {scope: :proposal_id}


  #TODO
  def desc_vote_schulze
    desc = ""
    #ids is an array of two. each element with his previous delimiter
    solution_ids = self.proposal.solutions.pluck(:id)
    ids = self.vote_schulze.scan(/(;|,|)(\d+)/).map { |d, n| [d, n.to_i] }.each do |d, n|
      desc += (d == ',' ? ' , ' : ' </br>') unless d.empty?
      desc += I18n.t("pages.proposals.edit.new_solution_title.#{self.proposal.proposal_type.name.downcase}", num: solution_ids.index(n)+1) + Solution.where(id: n).pluck(:title).first.to_s
    end
    desc.html_safe
  end
end
