defmodule Scrape.Flow.Steps.Text.CalculateSummaryTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.Text.CalculateSummary
  alias Scrape.IR.HTML

  test "refuses if no assigns are given" do
    assert CalculateSummary.execute(nil) == {:error, :no_assigns_given}
  end

  test "refuses if text not existing in state" do
    assert CalculateSummary.execute(%{}) == {:error, :text_missing}
  end

  test "refuses if text is nil" do
    assert CalculateSummary.execute(%{text: nil}) == {:error, :text_invalid}
  end

  test "works if non-empty text string is given" do
    html = File.read!("cache/article/nytimes.html")
    text = HTML.content(html)
    language = :en

    stems = [
      "wage",
      "minimum",
      "increas",
      "studi",
      "effect",
      "state",
      "employ",
      "worker",
      "econom",
      "job",
      "negat",
      "market",
      "labor",
      "rose",
      "exampl",
      "level",
      "trade",
      "rise",
      "rais",
      "economist",
      "educ",
      "net",
      "question",
      "best",
      "138",
      "competit",
      "cut",
      "power",
      "off",
      "teenag"
    ]

    {:ok, result} = CalculateSummary.execute(%{text: text, language: language, stems: stems})
    assert result.summary =~ "raising the minimum wage"
  end
end
