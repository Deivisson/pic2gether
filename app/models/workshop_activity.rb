class WorkshopActivity < ActiveRecord::Base
	validates :workshop_id, presence:true
	validates :description, presence:true, length: {maximum:100}
	validates :status, presence:true
  validates :maximum_upload_number, presence:true, numericality:true
  validates :limit_date, presence:true
  validate :limit_date_minor_than_today
  belongs_to :workshop
  has_many :responses, class_name: "WorkshopActivityResponse"

  attr_accessor :delivered_count, :perc_delivered

  def user_responses(user_id)
  	self.responses.where(user_id:user_id)
  end
	
  def time_over?
    Time.now.to_date > self.limit_date
  end

  def delivered_count
    @delivered_count ||= self.responses.select('user_id').distinct.count
  end

  def perc_delivered
    student_count = self.workshop.students.count
    return 0 if student_count == 0
    if @perc_delivered.nil? 
      @perc_delivered = (delivered_count.to_f / student_count.to_f) * 100
      @perc_delivered = 100 if @perc_delivered > 100
    end
    @perc_delivered
  end

  before_create :check_if_not_in_limit_of_workshop_plan
	after_create :notificate_students

private

  def notificate_students
    path = Rails.application.routes.url_helpers.user_workshop_path(id:self.workshop_id)
    url  = "<a href='#{path}'>#{self.workshop.description}</a>"
		attributes = {
      content: I18n.t("notifications.workshop_added_activity",workshop_url:url),
      type_of: Notification::TYPE_WORKSHOP_ADD_ACTIVITY,
      user_sender_id: self.workshop.user_id,
      read:false
  	}
    self.workshop.students.each do |student|
	  	attributes.merge!(user_receiver_id:student.id)  
      Notification.create!(attributes)
    end
  end

  def limit_date_minor_than_today
    return if self.limit_date.nil?
    if self.limit_date < Date.today
      errors[:limit_date] << I18n.t('activerecord.errors.messages.date_greater_than_or_equal_to', 
                                    date: I18n.localize(Date.today, :format => "%d/%m/%Y" ))
      return false
    end
  end

  def check_if_not_in_limit_of_workshop_plan
    unless self.workshop.can_add_activity?
      errors[:base] << I18n.t('activerecord.errors.messages.limit_activities_plan_end')
      return false
    end
  end  
end
