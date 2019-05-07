defmodule Scrape.Flow.Steps.CalculateSummary do
  @moduledoc false

  def execute(assigns), do: execute(assigns, Scrape.Options.merge())

  def execute(%{text: text, stems: stems, language: language}, _) do
    {:ok, %{summary: Scrape.IR.Text.extract_summary(text, stems, language)}}
  end
end
