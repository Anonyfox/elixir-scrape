defmodule Scrape.Flow.Steps.DetectLanguage do
  @moduledoc false

  def execute(state) when not is_map(state) do
    {:error, :no_state_given}
  end

  def execute(%{text: text}) when not is_binary(text) do
    {:error, :text_invalid}
  end

  def execute(%{text: text}) do
    {:ok, %{language: Scrape.IR.Text.detect_language(text)}}
  end

  def execute(_map) do
    {:error, :text_missing}
  end
end
