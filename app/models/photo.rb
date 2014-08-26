class Photo < ActiveRecord::Base
	
	validates :user_id, presence:true
	validates :picture, presence:true
	validates :category_id, presence:true

  belongs_to :user
  belongs_to :category
  has_one :exif, class_name:'PhotoExif'
  
  has_attached_file :picture, :styles => {small:"300x300", medium:"800x800"}, default_url:"/images/missing.png"
  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  after_post_process :save_exif

  def orientation
    self.exif.imagewidth > self.exif.imageheight ? "landscape" : "portrate"
  end

private 

  def save_exif
    #file = [Rails.root,"/public",self.picture.url(:original,timestamp:false)].join
    file = picture.queued_for_write[:original].path
    exif = MiniExiftool.new file
    attributes = {
      maker:exif.make,
      model:exif.model,
      lens:exif.lenstype,
      orientation:exif.orientation,
      shutter_speed:exif.shutterspeed,
      aperture:exif.fnumber,
      iso:exif.iso,
      taken_at:exif.createdate,
      flash:exif.flash,
      focal_lenght:exif.focallength,
      colorsapce:exif.colorspace,
      exposuremode:exif.exposuremode,
      whitebalance:exif.whitebalance,
      imagewidth:exif.imagewidth,
      imageheight:exif.imageheight,
      latitude:parse_latlong(exif.gpslatitude),
      longitude:parse_latlong(exif.gpslongitude)
    }
    self.exif = PhotoExif.new(attributes)
  end

  def parse_latlong(latlong)
    return unless latlong
    match, degrees, minutes, seconds, rotation = /(\d+) deg (\d+)' (.*)" (\w)/.match(latlong).to_a
    calculate_latlong(degrees, minutes, seconds, rotation)
  end

  def calculate_latlong(degrees, minutes, seconds, rotation)
    calculated_latlong = degrees.to_f + minutes.to_f/60 + seconds.to_f/3600
    ['S', 'W'].include?(rotation) ? -calculated_latlong : calculated_latlong
  end
end