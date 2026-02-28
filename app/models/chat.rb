# frozen_string_literal: true

class Chat < ApplicationRecord
  belongs_to :month
  has_many :messages, dependent: :destroy
end
