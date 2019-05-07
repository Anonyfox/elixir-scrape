defmodule Scrape.Flow.Steps.DetectLanguage do
  @moduledoc false

  def execute(assigns) when not is_map(assigns) do
    {:error, :no_assigns_given}
  end

  def execute(%{text: text}) when not is_binary(text) do
    {:error, :text_invalid}
  end

  def execute(%{text: text}) do
    {:ok, %{language: Scrape.IR.Text.detect_language(text)}}
  end

  def execute(_) do
    {:error, :text_missing}
  end
end
