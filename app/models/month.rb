class Month < ApplicationRecord
  belongs_to :user
  has_many :chats, dependent: :destroy

  validates :year,
            presence: true,
            numericality: { only_integer: true, greater_than: 1900 }

  validates :month,
            presence: true,
            uniqueness: {
              scope: [:year, :user_id],
              message: "already exists for this year"
            }

  validates :overview, length: { maximum: 1000 }
end
