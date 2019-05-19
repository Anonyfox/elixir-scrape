defmodule Scrape.Flow.Steps.Feed.ExtractDescriptionTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.Feed.ExtractDescription
  alias Scrape.Tools.Tree

  test "refuses if no assigns are given" do
    assert ExtractDescription.execute(nil) == {:error, :no_assigns_given}
  end

  test "refuses if tree not existing in state" do
    assert ExtractDescription.execute(%{}) == {:error, :tree_missing}
  end

  test "refuses if tree is nil" do
    assert ExtractDescription.execute(%{tree: nil}) == {:error, :tree_invalid}
  end

  test "refuses if tree is not parsed" do
    assert ExtractDescription.execute(%{tree: ""}) == {:error, :tree_invalid}
  end

  test "works if non-empty xml string is given" do
    tree = Tree.from_xml_string("<feed><description>abc</description></feed>")
    assert ExtractDescription.execute(%{tree: tree}) == {:ok, %{description: "abc"}}
  end

  test "transforms empty title to nil if nothing is found" do
    tree = Tree.from_xml_string("<feed />")
    assert ExtractDescription.execute(%{tree: tree}) == {:ok, %{description: nil}}
  end
end
