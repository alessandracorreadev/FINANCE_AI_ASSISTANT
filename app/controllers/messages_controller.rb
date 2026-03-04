# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_chat

  def create
    content = params.dig(:message, :content).to_s.strip
    if content.blank?
      return respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("message-form", partial: "messages/form", locals: { month: @month, chat: @chat, message: Message.new }), status: :unprocessable_entity }
        format.html { redirect_to month_chat_path(@month) }
      end
    end

    @user_message = @chat.messages.create!(role: "user", content: content)
    @assistant_message = @chat.messages.create!(role: "assistant", content: "")

    AiAssistantService.new(@chat).stream_response(
      assistant_message: @assistant_message,
      user_message_content: content
    ) { |msg| broadcast_replace_message(msg) }

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to month_chat_path(@month) }
    end
  rescue StandardError => e
    Rails.logger.error("MessagesController#create: #{e.message}")
    flash[:alert] = "Unable to get a response. Please try again."
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("message-form", partial: "messages/form", locals: { month: @month, chat: @chat, message: Message.new }), status: :unprocessable_entity }
      format.html { redirect_to month_chat_path(@month) }
    end
  end

  private

  def broadcast_replace_message(message)
    Turbo::StreamsChannel.broadcast_replace_to(
      @chat,
      target: helpers.dom_id(message),
      partial: "messages/message",
      locals: { message: message }
    )
  end

  def set_chat
    @month = current_user.months.find(params[:month_id])
    @chat = @month.chats.first_or_create!
  end
end
