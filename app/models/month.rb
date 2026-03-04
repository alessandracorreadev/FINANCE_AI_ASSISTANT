class Month < ApplicationRecord
  MONTH_ORDER = %w[January February March April May June July August September October November December].freeze

  belongs_to :user
  has_many :chats, dependent: :destroy

  validates :year,
            presence: true,
            numericality: { only_integer: true, greater_than: 1900 }

  validates :month,
            presence: true,
            inclusion: { in: MONTH_ORDER, message: "must be a valid month name (e.g. January)" },
            uniqueness: {
              scope: [:year, :user_id],
              message: "already exists for this year"
            }

  validates :overview, length: { maximum: 1000 }
end
