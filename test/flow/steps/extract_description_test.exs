defmodule Scrape.Flow.Steps.ExtractDescriptionTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.ExtractDescription

  test "refuses if no state is given" do
    assert ExtractDescription.execute(nil) == {:error, :no_state_given}
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

  test "works if non-empty html string is given" do
    dom = Floki.parse("<html><meta name='description' content='abc' /></html>")
    assert ExtractDescription.execute(%{dom: dom}) == {:ok, %{description: "abc"}}
  end

  test "transforms empty title to nil if nothing is found" do
    dom = Floki.parse("<html><body /></html>")
    assert ExtractDescription.execute(%{dom: dom}) == {:ok, %{description: nil}}
  end
end
