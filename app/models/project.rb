class Project < ActiveRecord::Base
  belongs_to :user
  has_many :contributions, dependent: :destroy
  has_many :items, dependent: :destroy
  after_save :get_video_info

  validates :title, presence: true
  validates :short_description, presence: true, length: { minimum: 5 }
  validates :extended_description, presence: true, length: { minimum: 100 }
  validates :funding_goal, presence: true, numericality: { greater_than: 0 }
  validates :funding_duration, presence: true, numericality: {greater_than: 0, less_than: 91}
  validates :media_link, presence: true, :format => URI::regexp(%w(http https))
  validates :project_url, :allow_blank => true, :format => URI::regexp(%w(http https))

  def total_contributed
    Contribution
      .where(project_id: self.id, payment_status: 'ACTIVE')
      .group(:project_id)
      .sum(:amount)
      .values[0].to_f
  end

  def total_contributors
   contributions
    .where(payment_status: 'ACTIVE')
    .select('DISTINCT(user_id)').count
  end

  def time_left
    return 0 unless created_at
    left = funding_duration - ((Time.now - created_at)/1.day).round
    left > 0 ? left : 0
  end

  def funding_percentage
    return 0.0 unless funding_goal.to_f > 0
    ((total_contributed.to_f / funding_goal.to_f) * 100)
  end

  def get_video_info
    if self.media_link.present?
      video = VideoInfo.get self.media_link
      self.update_columns(media_meta: video.to_yaml)
    end
  end
end
