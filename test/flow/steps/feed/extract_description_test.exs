defmodule Scrape.Flow.Steps.Feed.ExtractDescriptionTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.Feed.ExtractDescription

  test "refuses if no assigns are given" do
    assert ExtractDescription.execute(nil) == {:error, :no_assigns_given}
  end

  test "refuses if dom not existing in state" do
    assert ExtractDescription.execute(%{}) == {:error, :dom_missing}
  end

  test "refuses if dom is nil" do
    assert ExtractDescription.execute(%{dom: nil}) == {:error, :dom_invalid}
  end

  test "refuses if dom is not parsed" do
    assert ExtractDescription.execute(%{dom: ""}) == {:error, :dom_invalid}
  end

  test "works if non-empty xml string is given" do
    dom = Floki.parse("<feed><description>abc</description></feed>")
    assert ExtractDescription.execute(%{dom: dom}) == {:ok, %{description: "abc"}}
  end

  test "transforms empty title to nil if nothing is found" do
    dom = Floki.parse("<feed />")
    assert ExtractDescription.execute(%{dom: dom}) == {:ok, %{description: nil}}
  end
end
