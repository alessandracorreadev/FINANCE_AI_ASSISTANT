# frozen_string_literal: true

class ChatsController < ApplicationController
  before_action :set_month

  def show
    @chat = @month.chats.first_or_create!
    @messages = @chat.messages.order(:created_at)
  end

  private

  def set_month
    @month = current_user.months.find(params[:month_id])
  end
end
