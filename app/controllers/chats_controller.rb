# frozen_string_literal: true

# Chat de conselhos financeiros: tem acesso a tudo que foi cadastrado no mês (@month).
# A view/IA usa as informações financeiras do mês para dar orientação à pessoa.
class ChatsController < ApplicationController
  before_action :set_month

  def new
    @chat = @month.chats.build
    # Tudo cadastrado no mês está em @month (resumo, receitas, despesas, etc.).
    # Use @month e seus atributos para montar o contexto enviado à IA.
    @month_summary  = @month.overview
    @month_year     = @month.year
    @month_number   = @month.month
  end

  def create
    @chat = @month.chats.build
    if @chat.save
      redirect_to month_path(@month), notice: "Chat iniciado."
    else
      @month_summary = @month.overview
      @month_year    = @month.year
      @month_number  = @month.month
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_month
    @month = current_user.months.find(params[:month_id])
  end
end
