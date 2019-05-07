defmodule Scrape.Flow.Steps.ExtractImageURLTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.ExtractImageURL

  test "refuses if no assigns are given" do
    assert ExtractImageURL.execute(nil) == {:error, :no_assigns_given}
  end

  test "refuses if dom not existing in assigns" do
    assert ExtractImageURL.execute(%{}) == {:error, :dom_missing}
  end

  test "refuses if dom is nil" do
    assert ExtractImageURL.execute(%{dom: nil}) == {:error, :dom_invalid}
  end

  test "refuses if dom is not parsed" do
    assert ExtractImageURL.execute(%{dom: ""}) == {:error, :dom_invalid}
  end

  test "works if non-empty html string is given" do
    dom = Floki.parse("<html><meta property='og:image' content='/img.jpg' /></html>")
    assert ExtractImageURL.execute(%{dom: dom}) == {:ok, %{image_url: "/img.jpg"}}
  end

  test "does not normalize url if root_url is nil" do
    dom = Floki.parse("<html><meta property='og:image' content='/img.jpg' /></html>")
    url = nil
    {:ok, data} = ExtractImageURL.execute(%{dom: dom, url: url})
    assert data.image_url == "/img.jpg"
  end

  test "normalizes url if root_url is given" do
    dom = Floki.parse("<html><meta property='og:image' content='/img.jpg' /></html>")
    url = "http://example.com"
    {:ok, data} = ExtractImageURL.execute(%{dom: dom, url: url})
    assert data.image_url == "http://example.com/img.jpg"
  end

  test "transforms empty ImageURL to nil if nothing is found" do
    dom = Floki.parse("<html><body /></html>")
    assert ExtractImageURL.execute(%{dom: dom}) == {:ok, %{image_url: nil}}
  end
end
