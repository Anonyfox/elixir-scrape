defmodule Scrape.Flow.Steps.ExtractBody do
  @moduledoc false

  def execute(state) when not is_map(state) do
    {:error, :no_state_given}
  end

  def execute(%{html: html}) when not is_binary(html) do
    {:error, :html_invalid}
  end

  def execute(%{html: html}) do
    case Scrape.IR.DOM.paragraphs(html) do
      [] -> {:ok, %{body: nil}}
      paragraphs -> {:ok, %{body: paragraphs |> Enum.join(".\n\n")}}
    end
  end

  def execute(_state) do
    {:error, :html_missing}
  end
end
