defmodule Scrape.Flow.Steps.ExtractText do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{html: html}, _) when not is_binary(html) do
    fail(:html_invalid)
  end

  def execute(%{html: html}, _) do
    case content_from_html(html) do
      nil -> paragraphs_from_html(html)
      text -> text
    end
    |> assign_to(:text)
  end

  def execute(_, _) do
    fail(:html_missing)
  end

  defp content_from_html(html) do
    case Scrape.IR.DOM.content(html) do
      "" -> nil
      string -> string
    end
  end

  defp paragraphs_from_html(html) do
    text = html |> Scrape.IR.DOM.paragraphs() |> Enum.join(".\n\n")

    case text do
      "" -> nil
      string -> string
    end
  end
end
