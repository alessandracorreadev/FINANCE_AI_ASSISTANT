# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_chat

  def create
    service = AiAssistantService.new(@chat)
    service.call(params[:message][:content])

    redirect_to month_chat_path(@month)
  end

  private

  def set_chat
    @month = current_user.months.find(params[:month_id])
    @chat = @month.chats.first_or_create!
  end
end
