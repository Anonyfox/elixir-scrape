defmodule Scrape.Flow.Steps.CalculateStems do
  @moduledoc false

  def execute(%{text: text, language: language}) do
    {:ok, %{stems: Scrape.IR.Text.semantic_keywords(text, 30, language)}}
  end
end
