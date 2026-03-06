# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :chat

  validates :role, presence: true, inclusion: { in: %w[user assistant] }
  validates :content, presence: true, if: -> { role == "user" }

  after_create_commit :broadcast_append_to_chat, unless: :running_in_seed?

  private

  def broadcast_append_to_chat
    broadcast_remove_to chat, target: "empty-chat-message" if chat.messages.count == 1
    broadcast_append_to chat, target: "chat-messages", partial: "messages/message", locals: { message: self }
  end

  def running_in_seed?
    defined?(Rake) && Rake.application.top_level_tasks.include?("db:seed")
  end
end
