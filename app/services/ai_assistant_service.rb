# frozen_string_literal: true

class AiAssistantService
  def initialize(chat)
    @chat = chat
    @month = chat.month
  end

  def call(user_message)
    @chat.messages.create!(role: "user", content: user_message)

    prompt_with_history = build_prompt_with_history(user_message)

    response = RubyLLM.chat(model: "gpt-4o")
                      .with_instructions(system_prompt)
                      .ask(prompt_with_history)

    @chat.messages.create!(role: "assistant", content: response.content)

    response.content
  end

  private

  def build_prompt_with_history(current_message)
    previous_messages = @chat.messages.order(:created_at).last(10)

    return current_message if previous_messages.empty?

    history = previous_messages.map do |msg|
      role = msg.role == "user" ? "User" : "Assistant"
      "#{role}: #{msg.content}"
    end.join("\n\n")

    "Previous conversation:\n#{history}\n\nCurrent question: #{current_message}"
  end

  def system_prompt
    <<~PROMPT
      You are a friendly and experienced personal financial advisor.

      ## Context
      Month: #{@month.month} #{@month.year}

      ## User's Financial Overview
      #{@month.overview.presence || "No overview provided."}

      ## Extracted Financial Data
      #{financial_summary}

      ## Your Task
      - Answer questions about personal finances
      - Give practical advice to save money, invest, and organize the budget
      - Base your answers on the user's actual data shown above
      - If the user asks about something not in their data, ask them for more details

      ## Response Format
      - Keep responses concise (2-4 sentences max unless the user asks for details)
      - Use bullet points for lists
      - Be encouraging but realistic
      - Never invent data the user didn't provide
      - Respond in the same language the user writes to you
    PROMPT
  end

  def financial_summary
    data = @month.financial_data
    return "No financial data extracted yet." if data.blank?

    income = data["income"].to_f
    expenses = data["expenses"].to_f
    balance = income - expenses
    categories = data["categories"] || {}

    summary = "- Income: $#{income.round(2)}\n- Expenses: $#{expenses.round(2)}\n- Balance: $#{balance.round(2)}"

    if categories.any?
      summary += "\n- Expense breakdown:"
      categories.each { |cat, amount| summary += "\n  - #{cat}: $#{amount.to_f.round(2)}" }
    end

    summary
  end
end
