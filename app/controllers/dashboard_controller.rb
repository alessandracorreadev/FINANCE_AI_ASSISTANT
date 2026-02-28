# frozen_string_literal: true

class DashboardController < ApplicationController
  MONTH_ORDER = %w[January February March April May June July August September October November December].freeze

  def show
    @months = current_user.months.sort_by { |m| [-m.year, -MONTH_ORDER.index(m.month).to_i] }

    @total_income = 0
    @total_expenses = 0
    @categories = {}

    @months.each do |month|
      data = month.financial_data || {}
      @total_income += data["income"].to_f
      @total_expenses += data["expenses"].to_f

      (data["categories"] || {}).each do |cat, amount|
        @categories[cat] ||= 0
        @categories[cat] += amount.to_f
      end
    end

    @balance = @total_income - @total_expenses
    @savings_rate = @total_income > 0 ? ((@balance / @total_income) * 100).round(1) : 0
  end
end
