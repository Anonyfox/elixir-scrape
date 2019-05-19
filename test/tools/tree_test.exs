defmodule Scrape.Tools.TreeTest do
  use ExUnit.Case

  alias Scrape.Tools.Tree

  doctest Tree

  describe "Tree#from_string/1" do
    test "works with nil" do
      assert Tree.from_xml_string(nil) == %{}
    end

    test "works with empty string" do
      assert Tree.from_xml_string("") == %{}
    end

    test "works with xml string" do
      assert Tree.from_xml_string("<node>abc</node>") == %{"node" => "abc"}
    end
  end
end
