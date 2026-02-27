# frozen_string_literal: true

# Chat de conselhos financeiros: tem acesso a tudo que foi cadastrado no mês (@month).
# A view/IA usa as informações financeiras do mês para dar orientação à pessoa.
class ChatsController < ApplicationController
  before_action :set_month
  before_action :set_chat, only: [:show]

  def new
    @chat = @month.chats.build
    @month_summary  = @month.overview
    @month_year     = @month.year
    @month_number   = @month.month
  end

  def create
    @chat = @month.chats.build
    if @chat.save
      redirect_to month_chat_path(@month, @chat), notice: "Chat iniciado."
    else
      @month_summary = @month.overview
      @month_year    = @month.year
      @month_number  = @month.month
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @messages = @chat.messages.order(:created_at)
  end

  private

  def set_month
    @month = current_user.months.find(params[:month_id])
  end

  def set_chat
    @chat = @month.chats.find(params[:id])
  end
end
