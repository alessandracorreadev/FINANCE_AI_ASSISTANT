# frozen_string_literal: true

# Financial advice chat: has access to all month data (@month).
# One month has only one chat. Reuses existing or creates new.
class ChatsController < ApplicationController
  before_action :set_month

  def new
    @chat = @month.chats.first_or_create!
    redirect_to month_chat_path(@month, @chat)
  end

  def create
    @chat = @month.chats.first_or_create!
    redirect_to month_chat_path(@month, @chat)
  end

  def show
    @chat = @month.chats.find(params[:id])
    @messages = @chat.messages.order(:created_at)
  end

  private

  def set_month
    @month = current_user.months.find(params[:month_id])
  end
end
