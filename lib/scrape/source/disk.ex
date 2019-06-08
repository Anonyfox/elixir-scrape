defmodule Scrape.Source.Disk do
  @moduledoc """
  Abstraction over the native `File` functions. Currently without additional logic.
  """

  @doc """
  Same as `File.read/1`.
  """
  def get(path) do
    File.read(path)
  end

  @doc """
  Same as `File.read!/1`.
  """
  def get!(path) do
    File.read!(path)
  end
end
