# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_chat

  def create
    service = AiAssistantService.new(@chat)
    service.call(params[:message][:content])

    redirect_to month_chat_path(@chat.month, @chat)
  end

  private

  def set_chat
    @month = current_user.months.find(params[:month_id])
    @chat = @month.chats.find(params[:chat_id])
  end
end
