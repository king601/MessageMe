class Message < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :to_phone_number, :body
  validate :user_quota_limit


  after_commit :send_sms_job

  attr_reader :group_id

  def user_quota_limit
    self.user.quota_limit_check
    errors.add(:message, "would exceed your quota. So it cannot be sent.")
  end

  private
    def send_sms_job
      SendSmsJob.perform_later(self, self.user_id)
    end
end
