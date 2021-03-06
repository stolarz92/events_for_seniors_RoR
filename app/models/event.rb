class Event < ActiveRecord::Base
  belongs_to :city
  belongs_to :category
  belongs_to :user
  belongs_to :cost
  belongs_to :effort


  has_many :user_relationships,
           class_name:  "Relationship",
           foreign_key: "event_id",
           dependent:   :destroy

  has_many :attendants,
           through: :user_relationships,
           source: :user

  scope :ordered_by_time_asc, ->{ order('starts_at ASC') }
  scope :ordered_by_time_desc, ->{ order('starts_at DESC') }
  scope :ordered_by_date_asc, ->{ order('start_date ASC') }
  scope :ordered_by_date_desc, ->{ order('start_date DESC') }

  scope :closest, ->(date, time) { where("start_date >= ? AND starts_at >= ?", date, time) }


  has_attached_file :image,
                    :styles => {
                        :thumb    => ['200x200#',  :jpg, :quality => 70],
                        :small    => ['300x300#',  :jpg, :quality => 70],
                        :preview  => ['480x480#',  :jpg, :quality => 70],
                        :large    => ['600>',      :jpg, :quality => 70],
                        :retina   => ['1200>',     :jpg, :quality => 30]
                    },
                    :convert_options => {
                        :thumb    => '-set colorspace sRGB -strip',
                        :small    => '-set colorspace sRGB -strip',
                        :preview  => '-set colorspace sRGB -strip',
                        :large    => '-set colorspace sRGB -strip',
                        :retina   => '-set colorspace sRGB -strip -sharpen 0x0.5'
                    }
  validates_attachment :image,
                       :size => { :in => 0..4.megabytes },
                       :content_type => { :content_type => /^image\/(jpeg|png|gif|tiff)$/
                       }
  validates :name,
            :description,
            :start_date,
            :end_date,
            :location,
            :starts_at,
            :ends_at,
            :city_id,
            :contact,
            :website,
            :cost_id,
            :category_id,
            :effort_id,
            :user_id, presence: true

  validates :name, length: { in: 3..100 }
  validates :description, length: { in: 3..1000 }
  validates :location, length: { in: 3..100 }
  validates :contact, length: { in: 3..50 }
  validates :website, length: { in: 3..70 }

end
