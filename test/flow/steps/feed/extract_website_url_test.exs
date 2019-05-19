defmodule Scrape.Flow.Steps.Feed.ExtractWebsiteURLTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.Feed.ExtractWebsiteURL
  alias Scrape.Tools.Tree

  test "refuses if no assigns are given" do
    assert ExtractWebsiteURL.execute(nil) == {:error, :no_assigns_given}
  end

  test "refuses if tree not existing in assigns" do
    assert ExtractWebsiteURL.execute(%{}) == {:error, :tree_missing}
  end

  test "refuses if tree is nil" do
    assert ExtractWebsiteURL.execute(%{tree: nil}) == {:error, :tree_invalid}
  end

  test "refuses if tree is not parsed" do
    assert ExtractWebsiteURL.execute(%{tree: ""}) == {:error, :tree_invalid}
  end

  test "works if non-empty html string is given" do
    tree = Tree.from_xml_string("<rss><channel><link>http://example.com</link></channel><rss>")
    assert ExtractWebsiteURL.execute(%{tree: tree}) == {:ok, %{website_url: "http://example.com"}}
  end

  test "transforms empty website_url to nil if nothing is found" do
    tree = Tree.from_xml_string("<rss><channel></channel></rss>")
    assert ExtractWebsiteURL.execute(%{tree: tree}) == {:ok, %{website_url: nil}}
  end
end
