defmodule Scrape.Fetch do
  use HTTPoison.Base

  # http://www.erlang.org/doc/apps/stdlib/unicode_usage.html
  # http://www.erlang.org/doc/man/unicode.html
  # http://www.reddit.com/r/elixir/comments/39azpw/character_encoding_conversion_in_elixir/
  def run(url) do
    HTTPoison.get!(url).body
    # ToDo: binary to utf8 string conversion
    # if String.valid?(response)
    #   return response
    # else
    #   transcode response and return
    # end
  end
end