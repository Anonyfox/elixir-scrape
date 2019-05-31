defmodule Scrape.Tools.DomTest do
  use ExUnit.Case

  alias Scrape.Tools.DOM

  doctest DOM

  describe "DOM#from_string/1" do
    test "works with nil" do
      assert DOM.from_string(nil) == []
    end

    test "works with empty string" do
      assert DOM.from_string("") == []
    end

    test "works with html string with one root node" do
      assert DOM.from_string("<html />") == {"html", [], []}
    end

    test "works with html string with two root nodes" do
      assert DOM.from_string("<head /><body />") == [{"head", [], []}, {"body", [], []}]
    end
  end

  describe "DOM#to_string/1" do
    test "works with nil" do
      assert DOM.to_string(nil) == ""
    end

    test "works with empty dom" do
      assert DOM.to_string([]) == ""
    end

    test "works with dom with one root node" do
      assert DOM.to_string({"html", [], []}) == "<html></html>"
    end

    test "works with dom with two root nodes" do
      dom = [{"head", [], []}, {"body", [], []}]
      assert DOM.to_string(dom) == "<head></head><body></body>"
    end
  end

  describe "DOM#text/2" do
    test "returns nil if nothing is found" do
      dom = DOM.from_string("<p>hello world</p>")
      assert DOM.text(dom, "div") == nil
    end

    test "returns string if something is found" do
      dom = DOM.from_string("<p>hello world</p>")
      assert DOM.text(dom, "p") == "hello world"
    end

    test "returns first string if many matches are found" do
      dom = DOM.from_string("<p>hello</p><p>world</p>")
      assert DOM.text(dom, "p") == "hello"
    end
  end

  describe "DOM#texts/2" do
    test "returns empty list if nothing is found" do
      dom = DOM.from_string("<p>hello world</p>")
      assert DOM.texts(dom, "div") == []
    end

    test "returns string list if one match is found" do
      dom = DOM.from_string("<p>hello world</p>")
      assert DOM.texts(dom, "p") == ["hello world"]
    end

    test "returns string list if many matches are found" do
      dom = DOM.from_string("<p>hello</p><p>world</p>")
      assert DOM.texts(dom, "p") == ["hello", "world"]
    end
  end

  describe "DOM#attr/3" do
    test "returns nil if nothing is found" do
      dom = DOM.from_string("<meta name='a' content='b' />")
      assert DOM.attr(dom, "unknown", "unknown") == nil
      assert DOM.attr(dom, "meta", "unknown") == nil
      assert DOM.attr(dom, "meta[name='unknown']", "unknown") == nil
      assert DOM.attr(dom, "unknown", "content") == nil
    end

    test "returns string if something is found" do
      dom = DOM.from_string("<meta name='a' content='b' />")
      assert DOM.attr(dom, "meta[name='a']", "content") == "b"
    end

    test "returns first string if many matches are found" do
      dom = DOM.from_string("<meta name='a' content='b' /><meta name='a' content='c' />")
      assert DOM.attr(dom, "meta[name='a']", "content") == "b"
    end
  end

  describe "DOM#attrs/3" do
    test "returns empty list if nothing is found" do
      dom = DOM.from_string("<meta name='a' content='b' />")
      assert DOM.attrs(dom, "unknown", "unknown") == []
    end

    test "returns string list if one match is found" do
      dom = DOM.from_string("<meta name='a' content='b' /><meta name='c' content='d' />")
      assert DOM.attrs(dom, "meta[name=a]", "content") == ["b"]
    end

    test "returns string list if many matches are found" do
      dom = DOM.from_string("<meta name='a' content='b' /><meta name='a' content='c' />")
      assert DOM.attrs(dom, "meta[name=a]", "content") == ["b", "c"]
    end
  end
end
