# frozen_string_literal: true

class MonthsController < ApplicationController
  before_action :set_month, only: [:show, :edit, :update, :destroy]

  def index
    @months = current_user.months.order(year: :desc, month: :desc)
  end

  def new
    @month = current_user.months.build
  end

  def create
    @month = current_user.months.build(month_params)
    if @month.save
      redirect_to @month, notice: "Mês criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @month.update(month_params)
      redirect_to @month, notice: "Mês atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @month.destroy
    redirect_to months_path, notice: "Mês removido."
  end

  private

  def set_month
    @month = current_user.months.find(params[:id])
  end

  def month_params
    params.require(:month).permit(:year, :month, :summary)
  end
end
