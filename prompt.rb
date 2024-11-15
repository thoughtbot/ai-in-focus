class Prompt
  include ActiveModel::Model
  MODEL = "gpt-3.5-turbo".freeze

  class_attribute :config, :elastic_search

  attr_accessor :text, :filters, :response, :context

  def initialize(attributes = {})
    self.filters = attributes.fetch(:filters, Repository.all.map(&:result_type))
    self.context ||= ""
    super
  end

  def result
    @result ||= perform
  end

  def documents
    @documents = Search.new(q: text, filters: filters).perform
  end

  def build_context
    current_document = 0
    while current_document < documents.length && token_count(context) + token_count(document_for_result(documents[current_document])) < 3800
      self.context += document_for_result(documents[current_document])
      current_document += 1
    end
  end

  def perform
    if text.present?
      build_context
      reply = client.chat(
        parameters: {
          model: MODEL,
          messages: [{role: "user", content: content}],
          temperature: 0.0
        }
      )
      self.response = reply.dig("choices", 0, "message", "content")
    end
  end

  private

  def content
    <<~CONTENT
      #{context}
      Using only the information provided above, answer the following question and provide the url where the answer can be found: #{text}
    CONTENT
  end

  def document_for_result(result)
    "[#{result.name}](#{result.url})\n\n#{result.description}\n\n"
  end

  def token_count(string)
    encoding.encode(string).size
  end

  def client
    @client ||= OpenAI::Client.new
  end

  def encoding
    @encoding ||= Tiktoken.encoding_for_model(MODEL)
  end
end
