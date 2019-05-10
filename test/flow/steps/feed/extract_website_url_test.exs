defmodule Scrape.Flow.Steps.Feed.ExtractWebsiteURLTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.Feed.ExtractWebsiteURL

  test "refuses if no assigns are given" do
    assert ExtractWebsiteURL.execute(nil) == {:error, :no_assigns_given}
  end

  test "refuses if dom not existing in assigns" do
    assert ExtractWebsiteURL.execute(%{}) == {:error, :dom_missing}
  end

  test "refuses if dom is nil" do
    assert ExtractWebsiteURL.execute(%{dom: nil}) == {:error, :dom_invalid}
  end

  test "refuses if dom is not parsed" do
    assert ExtractWebsiteURL.execute(%{dom: ""}) == {:error, :dom_invalid}
  end

  test "works if non-empty html string is given" do
    dom = Floki.parse("<channel><link>http://example.com</link></channel>")
    assert ExtractWebsiteURL.execute(%{dom: dom}) == {:ok, %{website_url: "http://example.com"}}
  end

  test "transforms empty website_url to nil if nothing is found" do
    dom = Floki.parse("<channel></channel>")
    assert ExtractWebsiteURL.execute(%{dom: dom}) == {:ok, %{website_url: nil}}
  end
end
