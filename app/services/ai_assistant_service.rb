# frozen_string_literal: true

class AiAssistantService
  def initialize(chat)
    @chat = chat
    @month = chat.month
  end

  def call(user_message)
    # Salva a mensagem do usuário
    @chat.messages.create!(role: "user", content: user_message)

    # Chama a IA com o contexto do mês
    response = RubyLLM.chat(model: "gpt-4o")
                      .with_instructions(system_prompt)
                      .ask(user_message)

    # Salva a resposta da IA
    @chat.messages.create!(role: "assistant", content: response.content)

    response.content
  end

  private

  def system_prompt
    <<~PROMPT
      Você é um consultor financeiro pessoal amigável e experiente.

      Contexto: O usuário está analisando suas finanças do mês de #{@month.month} #{@month.year}.

      Resumo do mês fornecido pelo usuário:
      #{@month.overview.presence || "Nenhum resumo fornecido."}

      Tarefa: Responda perguntas sobre finanças pessoais, dê conselhos práticos
      para economizar, investir e organizar o orçamento com base nos dados do mês.

      Formato: Respostas claras e objetivas em português. Use listas quando apropriado.
      Seja encorajador mas realista. Não invente dados que o usuário não forneceu.
    PROMPT
  end
end
