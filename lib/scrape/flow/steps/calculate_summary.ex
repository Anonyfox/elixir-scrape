defmodule Scrape.Flow.Steps.CalculateSummary do
  @moduledoc false

  def execute(%{text: nil, body: body, language: language, stems: stems}) do
    {:ok, %{summary: Scrape.IR.Text.extract_summary(body, stems, language)}}
  end

  def execute(%{text: text, stems: stems, language: language}) do
    {:ok, %{summary: Scrape.IR.Text.extract_summary(text, stems, language)}}
  end
end
