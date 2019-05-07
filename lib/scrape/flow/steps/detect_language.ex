defmodule Scrape.Flow.Steps.DetectLanguage do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{text: text}, _) when not is_binary(text) do
    fail(:text_invalid)
  end

  def execute(%{text: text}, _) do
    assign(language: Scrape.IR.Text.detect_language(text))
  end

  def execute(_, _) do
    fail(:text_missing)
  end
end
