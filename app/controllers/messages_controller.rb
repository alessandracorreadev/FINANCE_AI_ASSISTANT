# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_chat

  def create
    @user_message, @assistant_message = AiAssistantService.new(@chat).call(params[:message][:content])

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

  def set_chat
    @month = current_user.months.find(params[:month_id])
    @chat = @month.chats.first_or_create!
  end
end
