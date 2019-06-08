defmodule Scrape.Options do
  @moduledoc false

  @defaults num_stems: 30

  def merge(opts \\ []) do
    Keyword.merge(@defaults, opts)
  end
end
