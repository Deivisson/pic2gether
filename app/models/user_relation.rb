class UserRelation < ActiveRecord::Base
	validates :user_id, presence:true
	validates :user_followed_id, presence:true, uniqueness: {scope: :user_id}

  belongs_to :user
  after_create :notificate_followed, :save_points_for_following_user, :save_points_for_followed_user

private 

  def notificate_followed
		link = "<a class='photographer-profile' href='/user/photographers/#{user_id}'>#{self.user.profile.user_name} </a> "
		attributes = {
      content: I18n.t("notifications.followed",follower: link),
      type_of: Notification::TYPE_FOLLOWED,
      user_sender_id: self.user_id,
      user_receiver_id: self.user_followed_id,
      read:false
    }
    Notification.create!(attributes)
  end

  #Save the points for user that is following
  def save_points_for_following_user
    UserPoint.save_points(self.user_id, UserPoint::FOLLOW, 
                          {userx_id:self.user_followed_id})
  end

  #Save the points for followed user
  def save_points_for_followed_user
    UserPoint.save_points(self.user_followed_id, UserPoint::BE_FOLLOWED, 
                          {userx_id:self.user_id})
  end

end
