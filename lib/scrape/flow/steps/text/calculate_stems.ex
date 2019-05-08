defmodule Scrape.Flow.Steps.Text.CalculateStems do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{text: text}, _) when not is_binary(text) do
    fail(:text_invalid)
  end

  def execute(%{text: text, language: language}, _) do
    assign(stems: Scrape.IR.Text.semantic_keywords(text, 30, language))
  end

  def execute(_, _) do
    fail(:text_missing)
  end
end
