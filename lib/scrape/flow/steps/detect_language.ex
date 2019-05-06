defmodule Scrape.Flow.Steps.DetectLanguage do
  @moduledoc false

  def execute(%{text: nil, body: body}) do
    {:ok, %{language: Scrape.IR.Text.detect_language(body)}}
  end

  def execute(%{text: text}) do
    {:ok, %{language: Scrape.IR.Text.detect_language(text)}}
  end
end
