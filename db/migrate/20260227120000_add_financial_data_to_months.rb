# frozen_string_literal: true

class AddFinancialDataToMonths < ActiveRecord::Migration[7.1]
  def change
    add_column :months, :financial_data, :jsonb, default: {}
  end
end
