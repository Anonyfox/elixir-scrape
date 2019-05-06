defmodule Scrape.Source.Disk do
  def get(path) do
    File.read(path)
  end
end
