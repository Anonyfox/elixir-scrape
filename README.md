
# Scrape

[![Hex.pm](https://img.shields.io/hexpm/dt/scrape.svg)](https://hex.pm/packages/scrape)
[![Hex.pm](https://img.shields.io/hexpm/v/scrape.svg)](https://hex.pm/packages/scrape)
[![Hex.pm](https://img.shields.io/hexpm/l/scrape.svg)](https://hex.pm/packages/scrape)

## Installation

The package can be installed by adding `scrape` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:scrape, "~> 3.0.0"}
  ]
end
```

## Usage

* `Scrape.domain!(url)` -> get structured data of a domain-type url (like https://bbc.com)
* `Scrape.feed!(url)` -> get structured data of a RSS/Atom feed
* `Scrape.article!(url)` -> get structured data of an article-type url 

## License

LGPLv3. You can use this package any way you want (including commercially), but I want bugfixes and improvements to flow back into this package.
