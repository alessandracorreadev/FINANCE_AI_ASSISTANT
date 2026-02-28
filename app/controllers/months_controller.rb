# frozen_string_literal: true

class MonthsController < ApplicationController
  MONTH_ORDER = %w[January February March April May June July August September October November December].freeze

  before_action :set_month, only: [:show, :edit, :update, :destroy]

  def index
    @months = current_user.months.sort_by { |m| [-m.year, -MONTH_ORDER.index(m.month).to_i] }
  end

  def new
    @month = current_user.months.build
  end

  def create
    @month = current_user.months.build(month_params)
    if @month.save
      extract_financial_data(@month)
      redirect_to @month, notice: "Month created successfully."
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
      extract_financial_data(@month)
      redirect_to @month, notice: "Month updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @month.destroy
    redirect_to months_path, notice: "Month deleted."
  end

  private

  def set_month
    @month = current_user.months.find(params[:id])
  end

  def month_params
    params.require(:month).permit(:year, :month, :overview)
  end

  def extract_financial_data(month)
    data = ExtractFinancialDataService.new(month).call
    month.update(financial_data: data)
  end
end
