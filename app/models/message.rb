# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :chat

  validates :role, presence: true, inclusion: { in: %w[user assistant] }
  validates :content, presence: true, if: -> { role == "user" }

  after_create_commit :broadcast_append_to_chat

  private

  def broadcast_append_to_chat
    broadcast_remove_to chat, target: "empty-chat-message" if chat.messages.count == 1
    broadcast_append_to chat, target: "chat-messages", partial: "messages/message", locals: { message: self }
  end
end
