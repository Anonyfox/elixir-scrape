defmodule Scrape.Flow.Steps.ExtractIconURLTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.ExtractIconURL

  test "refuses if no state is given" do
    assert ExtractIconURL.execute(nil) == {:error, :no_state_given}
  end

  test "refuses if dom not existing in state" do
    assert ExtractIconURL.execute(%{}) == {:error, :dom_missing}
  end

  test "refuses if dom is nil" do
    assert ExtractIconURL.execute(%{dom: nil}) == {:error, :dom_invalid}
  end

  test "refuses if dom is not parsed" do
    assert ExtractIconURL.execute(%{dom: ""}) == {:error, :dom_invalid}
  end

  test "works if non-empty html string is given" do
    dom = Floki.parse("<html><link rel='icon' href='/img.jpg'></html>")
    assert ExtractIconURL.execute(%{dom: dom}) == {:ok, %{icon_url: "/img.jpg"}}
  end

  test "does not normalize url if root_url is nil" do
    dom = Floki.parse("<html><link rel='icon' href='/img.jpg'></html>")
    url = nil
    {:ok, data} = ExtractIconURL.execute(%{dom: dom, url: url})
    assert data.icon_url == "/img.jpg"
  end

  test "normalizes url if root_url is given" do
    dom = Floki.parse("<html><link rel='icon' href='/img.jpg'></html>")
    url = "http://example.com"
    {:ok, data} = ExtractIconURL.execute(%{dom: dom, url: url})
    assert data.icon_url == "http://example.com/img.jpg"
  end

  test "transforms empty IconURL to nil if nothing is found" do
    dom = Floki.parse("<html><body /></html>")
    assert ExtractIconURL.execute(%{dom: dom}) == {:ok, %{icon_url: nil}}
  end
end
