defmodule Scrape.Flow.Steps.ParseHTMLTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.ParseHTML

  test "refuses if mo assigns are given" do
    assert ParseHTML.execute(nil) == {:error, :html_missing}
  end

  test "refuses if nil is given" do
    assert ParseHTML.execute(%{html: nil}) == {:error, {:html_error, nil}}
  end

  test "refuses if number is given" do
    assert ParseHTML.execute(%{html: 1}) == {:error, {:html_error, 1}}
  end

  test "refuses if character list is given" do
    assert ParseHTML.execute(%{html: 'abc'}) == {:error, {:html_error, 'abc'}}
  end

  test "refuses if empty string is given" do
    assert ParseHTML.execute(%{html: ""}) == {:error, {:html_error, ""}}
  end

  test "works if non-empty html string is given" do
    assert ParseHTML.execute(%{html: "<body />"}) == {:ok, %{dom: {"body", [], []}}}
  end
end
