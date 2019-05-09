defmodule Scrape.Flow.Steps.Text.DetectLanguageTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.Text.DetectLanguage

  test "refuses if no assigns are given" do
    assert DetectLanguage.execute(nil) == {:error, :no_assigns_given}
  end

  test "refuses if text not existing in state" do
    assert DetectLanguage.execute(%{}) == {:error, :text_missing}
  end

  test "refuses if text is nil" do
    assert DetectLanguage.execute(%{text: nil}) == {:error, :text_invalid}
  end

  test "works if non-empty text string is given" do
    text = "hello, wonderful world!"
    assert DetectLanguage.execute(%{text: text}) == {:ok, %{language: :en}}
  end
end