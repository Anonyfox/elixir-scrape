defmodule Scrape.Flow.Steps.CalculateStemsTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.CalculateStems
  alias Scrape.IR.DOM

  test "refuses if no assigns are given" do
    assert CalculateStems.execute(nil) == {:error, :no_assigns_given}
  end

  test "refuses if text not existing in state" do
    assert CalculateStems.execute(%{}) == {:error, :text_missing}
  end

  test "refuses if text is nil" do
    assert CalculateStems.execute(%{text: nil}) == {:error, :text_invalid}
  end

  test "works if non-empty text string is given" do
    html = File.read!("cache/article/nytimes.html")
    text = DOM.content(html)
    language = :en
    {:ok, result} = CalculateStems.execute(%{text: text, language: language})
    assert "wage" in result.stems
    assert "minimum" in result.stems
    assert "economist" in result.stems
  end
end
