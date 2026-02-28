# frozen_string_literal: true

RubyLLM.configure do |config|
  config.openai_api_key = ENV["GITHUB_TOKEN"]
  config.openai_api_base = "https://models.inference.ai.azure.com"
# >>>>>>> 5b28ea8030f17a33525089480018bcc60f357fa2
end
