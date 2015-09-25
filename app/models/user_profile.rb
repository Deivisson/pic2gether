require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
class UserProfile < ActiveRecord::Base

  validates :user_name, presence:true
  validates :full_name, presence:true, length: {maximum:100}, uniqueness:true
  
  has_attached_file :avatar, 
                    :styles => { :medium => "500x500>", :thumb => "100x100>" }, 
                    :default_url => "user/no_avatar.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  belongs_to :user
  belongs_to :category
  belongs_to :city

  attr_accessor :country_id, :state_id, :avatar_remote_url

  before_create :set_initial_datas

  def state_id
  	if @state_id.nil? && !self.city_id.nil?
  		@state_id = self.city.state_id
  	end
  	@state_id
  end

  def country_id
  	if @country_id.nil? && !self.city_id.nil?
  		@country_id = self.city.state.country_id
  	end
  	@country_id
  end

  def cover_url(size=:medium)
    photo_url = ""
    unless cover_photo_id.nil?
      photo = Photo.find(cover_photo_id)
      photo_url = photo.picture.url(size) unless photo.nil?
    end
    return photo_url
  end

  def short_name
    self.full_name.truncate(18)
  end

private 
  
  def set_initial_datas
    self.category_id = Category::DEFAULT_CATEGORY_ID
    self.limit_upload_photo_by_day = 1
    if self.avatar_remote_url.present?
      self.avatar = URI.parse(self.avatar_remote_url)
    end
  end 
end
