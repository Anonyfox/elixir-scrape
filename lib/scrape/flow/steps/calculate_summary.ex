defmodule Scrape.Flow.Steps.CalculateSummary do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{text: text}, _) when not is_binary(text) do
    fail(:text_invalid)
  end

  def execute(%{text: text, stems: stems, language: language}, _) do
    assign(summary: Scrape.IR.Text.extract_summary(text, stems, language))
  end

  def execute(_, _) do
    fail(:text_missing)
  end
end
