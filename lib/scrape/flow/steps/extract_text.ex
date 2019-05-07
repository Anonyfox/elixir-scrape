defmodule Scrape.Flow.Steps.ExtractText do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{html: html}, _) when not is_binary(html) do
    fail(:html_invalid)
  end

  def execute(%{html: html}, _) do
    text =
      case content_from_html(html) do
        nil ->
          case paragraphs_from_html(html) do
            "" -> nil
            paragraphs -> paragraphs
          end

        "" ->
          case paragraphs_from_html(html) do
            "" -> nil
            paragraphs -> paragraphs
          end

        text ->
          case text do
            "" -> nil
            paragraphs -> paragraphs
          end
      end

    assign(text: text)
  end

  def execute(_, _) do
    fail(:html_missing)
  end

  defp content_from_html(html) do
    Scrape.IR.DOM.content(html)
  end

  defp paragraphs_from_html(html) do
    html |> Scrape.IR.DOM.paragraphs() |> Enum.join(".\n\n")
  end
end
