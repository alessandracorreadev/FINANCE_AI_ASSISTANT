# frozen_string_literal: true

class ExtractFinancialDataService
  def initialize(month)
    @month = month
  end

  def call
    return default_data if @month.overview.blank?

    response = RubyLLM.chat(model: "gpt-4o")
                      .with_instructions(system_prompt)
                      .ask(@month.overview)

    parse_response(response.content)
  rescue StandardError => e
    Rails.logger.error("ExtractFinancialDataService error: #{e.message}")
    default_data
  end

  private

  def system_prompt
    <<~PROMPT
      You are a financial data extractor. Analyze the text and extract financial information.

      Return ONLY a valid JSON object with this exact structure:
      {
        "income": 0,
        "expenses": 0,
        "categories": {}
      }

      Rules:
      - "income" = total income/earnings mentioned (number)
      - "expenses" = total expenses mentioned (number)
      - "categories" = breakdown of expenses by category (object with category names as keys and amounts as values)
      - If a value is not mentioned, use 0
      - Extract any expense categories you can identify (rent, food, transport, utilities, etc.)
      - Return ONLY the JSON, no explanation or markdown
    PROMPT
  end

  def parse_response(content)
    json_content = content.gsub(/```json\n?/, "").gsub(/```\n?/, "").strip
    data = JSON.parse(json_content)

    {
      "income" => data["income"].to_f,
      "expenses" => data["expenses"].to_f,
      "categories" => data["categories"] || {}
    }
  rescue JSON::ParserError => e
    Rails.logger.error("Failed to parse AI response: #{e.message}")
    default_data
  end

  def default_data
    { "income" => 0, "expenses" => 0, "categories" => {} }
  end
end
