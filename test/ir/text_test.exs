defmodule Scrape.IR.TextTest do
  use ExUnit.Case

  alias Scrape.IR.Text

  doctest Text

  test "greets the world" do
    example = "lorem ipsum..."
    assert Text.extract_summary(example) == example
    assert Text.generate_summary(example) == example
  end
end
