defmodule Scrape.Flow.Steps.DetectLanguage do
  @moduledoc false

  def execute(assigns), do: execute(assigns, Scrape.Options.merge())

  def execute(assigns, _) when not is_map(assigns) do
    {:error, :no_assigns_given}
  end

  def execute(%{text: text}, _) when not is_binary(text) do
    {:error, :text_invalid}
  end

  def execute(%{text: text}, _) do
    {:ok, %{language: Scrape.IR.Text.detect_language(text)}}
  end

  def execute(_, _) do
    {:error, :text_missing}
  end
end
