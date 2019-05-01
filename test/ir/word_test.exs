defmodule Scrape.IR.WordTest do
  use ExUnit.Case

  alias Scrape.IR.Word

  doctest Word

  test "can detect language of Word" do
    assert Scrape.IR.Word.stem("beautiful", :en) == "beauti"
    assert Scrape.IR.Word.stem("derbsten", :de) == "derb"
  end
end
