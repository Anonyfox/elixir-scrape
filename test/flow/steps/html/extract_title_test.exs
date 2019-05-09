defmodule Scrape.Flow.Steps.HTML.ExtractTitleTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.HTML.ExtractTitle

  test "refuses if no assigns are given" do
    assert ExtractTitle.execute(nil) == {:error, :no_assigns_given}
  end

  test "refuses if dom not existing in assigns" do
    assert ExtractTitle.execute(%{}) == {:error, :dom_missing}
  end

  test "refuses if dom is nil" do
    assert ExtractTitle.execute(%{dom: nil}) == {:error, :dom_invalid}
  end

  test "refuses if dom is not parsed" do
    assert ExtractTitle.execute(%{dom: ""}) == {:error, :dom_invalid}
  end

  test "works if non-empty html string is given" do
    dom = Floki.parse("<html><title>abc</title></html>")
    assert ExtractTitle.execute(%{dom: dom}) == {:ok, %{title: "abc"}}
  end

  test "transforms empty title to nil if nothing is found" do
    dom = Floki.parse("<html><body /></html>")
    assert ExtractTitle.execute(%{dom: dom}) == {:ok, %{title: nil}}
  end
end