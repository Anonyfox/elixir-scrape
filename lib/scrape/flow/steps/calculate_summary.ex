defmodule Scrape.Flow.Steps.CalculateSummary do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{text: text, stems: stems, language: language}, _) do
    assign(summary: Scrape.IR.Text.extract_summary(text, stems, language))
  end
end
