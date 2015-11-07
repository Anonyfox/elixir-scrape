# Scrape

[![Hex.pm](https://img.shields.io/hexpm/dt/scrape.svg)](https://hex.pm/packages/scrape)
[![Hex.pm](https://img.shields.io/hexpm/v/scrape.svg)](https://hex.pm/packages/scrape)
[![Hex.pm](https://img.shields.io/hexpm/l/scrape.svg)](https://hex.pm/packages/scrape)

An Elixir package to scrape websites. This is an attempt to rewrite
[meteor-scrape](https://github.com/Anonyfox/meteor-scrape) from scratch,
leveraging the expressiveness and power of Elixir. Current features:

- can handle non-utf-8 sources.
- can deal with timezones.
- parse RSS/Atom feeds.
- parse common websites.
- parse advanced content websites ("articles").

## Installation

Add `scrape` to your mixfile:

````Elixir
{:scrape, "~> 1.0"}
````

## Usage

````Elixir
# Feed scraping:
Scrape.feed "http://feeds.venturebeat.com/VentureBeat"

# result (list of items):
[
  %{
    description: "GUEST: For years, many have believed the startup world would be doomed by the “Series A Crunch,” the natural result of an explosion of seed funding paired with an increasingly high bar required to earn a Series A. Industry observers believed we’d be witnessing a train wreck of epic proportions as companies died off. But the […]",
    image: "http://i1.wp.com/venturebeat.com/wp-content/uploads/2015/11/seed-extensions.jpg?resize=160%2C140",
    pubdate: %Timex.DateTime{
      calendar: :gregorian, day: 7,
      hour: 19, minute: 0, month: 11, ms: 0, second: 23,
      timezone: %Timex.TimezoneInfo{
        abbreviation: "UTC",
        from: :min, full_name: "UTC", offset_std: 0,
        offset_utc: 0, until: :max
      },
      year: 4015
    },
   tags: [
     %{accuracy: 0.9, name: "micah rosenbloom"},
     %{accuracy: 0.9, name: "deals"},
     %{accuracy: 0.9, name: "seed funding"},
     %{accuracy: 0.9, name: "series a crunch"},
     %{accuracy: 0.9, name: "business"}
    ],
    title: "Why seed ‘extensions’ are becoming the new normal in fundraising",
    url: "http://venturebeat.com/2015/11/07/why-seed-extensions-are-becoming-the-new-normal-in-fundraising/"},
    %{...},
  ...
]
````

````Elixir
# Scrape a website:
Scrape.website "http://www.latimes.com"

# Result (basic metadata):
%Scrape.Website{
  description: "The LA Times is a leading source of breaking news, entertainment, sports, politics, and more for Southern California and the world.",
  favicon: "http://www.trbas.com/jive/prod/common/images/lanews-apple-touch-icon.1q2w3_9ffdb679907f116af126c65ff1edb27a.png",
  feeds: ["http://www.latimes.com/rss2.0.xml"],
  image: nil,
  tags: [
    %{accuracy: 0.9, name: "california"},
    %{accuracy: 0.9, name: "california news"},
    %{accuracy: 0.9, name: "lakers coverage"},
    %{accuracy: 0.9, name: "west coast news"},
    ...
  ],
  title: "Los Angeles Times - California, national and world news - Los Angeles Times",
  url: "http://www.latimes.com/"}
````

````Elixir
# Scrape an article (aka "content website")
Scrape.article "http://www.bbc.com/news/world-europe-34753464"

# Result
%Scrape.Article{
  description: "The Russian plane crash in Egypt was not due to technical failures, say French aviation officials, adding that the flight data recorder suggests a \"violent, sudden\" explosion.",
  favicon: "http://static.bbci.co.uk/news/1.96.1453/apple-touch-icon.png",
  fulltext: "Other French officials said the flight data recorder suggested a \"violent, sudden\" explosion caused the crash, killing all 224 people on board.\n\nThe Metrojet Airbus A321 was flying [...shortened...]",
  image: "http://ichef.bbci.co.uk/news/1024/cpsprodpb/A4F2/production/_86562224_86562223.jpg",
  tags: [%{accuracy: 0.7628205128205128, name: "french"},
  %{accuracy: 0.6730769230769231, name: "technical"},
  %{accuracy: 0.6730769230769231, name: "plane"},
  %{accuracy: 0.5384615384615385, name: "bbc"},
  %{accuracy: 0.40384615384615385, name: "newsrussian"},
  %{accuracy: 0.358974358974359, name: "flight"},
  %{accuracy: 0.358974358974359, name: "egypt"},
  %{accuracy: 0.3141025641025641, name: "russian"},
  %{accuracy: 0.3141025641025641, name: "data"},
  %{accuracy: 0.3141025641025641, name: "recorder"},
  ...
  ],
  title: "Russian plane crash: French 'rule out technical failure' - BBC News",
  url: "http://www.bbc.com/news/world-europe-34753464"}
````

## License

LGPLv3. Use this library however you want, but I want improvements & bugfixes
to flow back into this package.
