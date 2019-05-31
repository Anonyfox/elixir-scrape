defmodule Scrape.IR.TextTest do
  use ExUnit.Case

  alias Scrape.IR.Text

  doctest Text

  # test "greets the world" do
  #   example = "lorem ipsum..."
  #   assert Text.extract_summary(example, ["lorem"]) == ["lorem ipsum"]
  #   assert Text.generate_summary(example) == example
  # end

  test "can detect language of text" do
    assert Text.detect_language("the quick brown fox jumps over...") == :en
    assert Text.detect_language("Es ist ein schönes Wetter heute...") == :de
  end
end
