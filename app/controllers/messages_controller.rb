# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_chat

  def create
    @user_message = @chat.messages.create!(role: "user", content: params[:message][:content])

    llm_chat = RubyLLM.chat(model: "gpt-4o")
                      .with_instructions(system_prompt)

    previous_messages = @chat.messages.where.not(id: @user_message.id).order(:created_at)
    previous_messages.each do |msg|
      llm_chat.add_message(role: msg.role, content: msg.content)
    end

    response = llm_chat.ask(params[:message][:content])

    @assistant_message = @chat.messages.create!(role: "assistant", content: response.content)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to month_chat_path(@month) }
    end
  end

  private

  def set_chat
    @month = current_user.months.find(params[:month_id])
    @chat = @month.chats.first_or_create!
  end

  def system_prompt
    <<~PROMPT
      You are a personal finance advisor.

      Month: #{@month.month} #{@month.year}
      Overview: #{@month.overview.presence || "None provided."}

      Rules:
      - Keep responses SHORT (max 3 sentences)
      - Use bullet points when listing
      - Be direct and practical
      - Remember the conversation history
    PROMPT
  end
end
