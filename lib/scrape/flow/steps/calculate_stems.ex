defmodule Scrape.Flow.Steps.CalculateStems do
  @moduledoc false

  def execute(%{text: nil, body: body, language: language}) do
    {:ok, %{stems: Scrape.IR.Text.semantic_keywords(body, 30, language)}}
  end

  def execute(%{text: text, language: language}) do
    {:ok, %{stems: Scrape.IR.Text.semantic_keywords(text, 30, language)}}
  end
end
