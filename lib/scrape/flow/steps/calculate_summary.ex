defmodule Scrape.Flow.Steps.CalculateSummary do
  @moduledoc false

  def execute(%{text: text, stems: stems, language: language}) do
    {:ok, %{summary: Scrape.IR.Text.extract_summary(text, stems, language)}}
  end
end
