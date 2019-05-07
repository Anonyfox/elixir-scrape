defmodule Scrape.Flow.Steps.CalculateStems do
  @moduledoc false

  def execute(assigns), do: execute(assigns, Scrape.Options.merge())

  def execute(%{text: text, language: language}, _) do
    {:ok, %{stems: Scrape.IR.Text.semantic_keywords(text, 30, language)}}
  end
end
