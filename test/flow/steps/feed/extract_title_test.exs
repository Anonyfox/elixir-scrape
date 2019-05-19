defmodule Scrape.Flow.Steps.Feed.ExtractTitleTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.Feed.ExtractTitle
  alias Scrape.Tools.Tree

  test "refuses if no assigns are given" do
    assert ExtractTitle.execute(nil) == {:error, :no_assigns_given}
  end

  test "refuses if tree not existing in assigns" do
    assert ExtractTitle.execute(%{}) == {:error, :tree_missing}
  end

  test "refuses if tree is nil" do
    assert ExtractTitle.execute(%{tree: nil}) == {:error, :tree_invalid}
  end

  test "refuses if tree is not parsed" do
    assert ExtractTitle.execute(%{tree: ""}) == {:error, :tree_invalid}
  end

  test "works if non-empty html string is given" do
    tree = Tree.from_xml_string("<feed><title>abc</title></feed>")
    assert ExtractTitle.execute(%{tree: tree}) == {:ok, %{title: "abc"}}
  end

  test "transforms empty title to nil if nothing is found" do
    tree = Tree.from_xml_string("<feed></feed>")
    assert ExtractTitle.execute(%{tree: tree}) == {:ok, %{title: nil}}
  end
end
