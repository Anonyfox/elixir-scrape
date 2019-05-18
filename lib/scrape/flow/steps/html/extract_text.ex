defmodule Scrape.Flow.Steps.HTML.ExtractText do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{html: html}, _) when not is_binary(html) do
    fail(:html_invalid)
  end

  def execute(%{html: html}, _) do
    assign(text: Scrape.IR.HTML.content(html) || Scrape.IR.HTML.sentences(html))
  end

  def execute(_, _) do
    fail(:html_missing)
  end
end
