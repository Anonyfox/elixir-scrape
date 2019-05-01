defmodule Scrape.IR.WordTest do
  use ExUnit.Case

  alias Scrape.IR.Word

  doctest Word

  describe "Word.stem/2" do
    test "can stem english words" do
      assert Word.stem("beautiful", :en) == "beauti"
    end

    test "can stem german words" do
      assert Word.stem("derbsten", :de) == "derb"
    end
  end

  describe "Word.is_stopword?/2" do
    test "can check english words" do
      assert Word.is_stopword?("a", :en) == true
      assert Word.is_stopword?("apple", :en) == false
    end

    test "can check german words" do
      assert Word.is_stopword?("eine", :de) == true
      assert Word.is_stopword?("vitamin", :de) == false
    end
  end
end
