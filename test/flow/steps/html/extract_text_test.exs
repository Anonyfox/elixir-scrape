defmodule Scrape.Flow.Steps.HTML.ExtractTextTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.HTML.ExtractText

  test "refuses if no assigns are given" do
    assert ExtractText.execute(nil) == {:error, :no_assigns_given}
  end

  test "refuses if html not existing in assigns" do
    assert ExtractText.execute(%{}) == {:error, :html_missing}
  end

  test "refuses if html is nil" do
    assert ExtractText.execute(%{html: nil}) == {:error, :html_invalid}
  end

  test "works if non-empty html string is given" do
    html = "cache/article/nytimes.html" |> File.read!()
    {:ok, %{text: text}} = ExtractText.execute(%{html: html})
    assert text =~ "Minimum Wage Increases Have Trade-Offs"
  end

  test "transforms empty text to nil if nothing is found" do
    html = "<html><body /></html>"
    assert ExtractText.execute(%{html: html}) == {:ok, %{text: nil}}
  end
end
