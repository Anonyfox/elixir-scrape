defmodule Scrape.Flow.Steps.CalculateStems do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{text: text, language: language}, _) do
    assign(stems: Scrape.IR.Text.semantic_keywords(text, 30, language))
  end
end
