# Scrape

[![Hex.pm](https://img.shields.io/hexpm/dt/scrape.svg)](https://hex.pm/packages/scrape)
[![Hex.pm](https://img.shields.io/hexpm/v/scrape.svg)](https://hex.pm/packages/scrape)
[![Hex.pm](https://img.shields.io/hexpm/l/scrape.svg)](https://hex.pm/packages/scrape)

An Elixir package to scrape websites. This is an attempt to rewrite
[meteor-scrape](https://github.com/Anonyfox/meteor-scrape) from scratch,
leveraging the expressiveness and power of Elixir. Current features:

- extremely fast browser-grade HTML parser, as a **Rust NIF**
- can handle non-utf-8 sources.
- can deal with timezones.
- parse RSS/Atom feeds.
- parse common websites.
- parse advanced content websites ("articles").

## Installation

The latest version does include a major braking change regarding installation:
**you'll need a Rust compiler installed**. The heavy lifting part of parsing
HTML/XML is now done with html5ever, the core of Servo (Mozillas new rendering
Engine for firefox written in Rust). This is included as a NIF written in Rust,
so you have the maximum performance *and* it will not segfault/... like C/C++.
Worth mentioning is also that this HTML parser is highly resilent with
malformed HTML/XML, just as a webbrowser nowadays, and does not give up when
some illegal structures appear in the code (like, in some amateur websites).

The easiest way to get a rust compiler installed is via
[rustup.rs](https://www.rustup.rs), with the oneliner:

`curl https://sh.rustup.rs -sSf | sh`

Once you have Rust installed, add `scrape` to your mixfile:

````Elixir
{:scrape, "~> 2.0"}
````

and add `:scrape` to your applications list in your mixfile.

## Usage

````Elixir
# Feed scraping:
Scrape.feed "http://feeds.feedburner.com/venturebeat/SZYF"

# result (list of items):
[
  %{
    description: "GUEST: For years, many have believed the startup world would be doomed by the “Series A Crunch,” the natural result of an explosion of seed funding paired with an increasingly high bar required to earn a Series A. Industry observers believed we’d be witnessing a train wreck of epic proportions as companies died off. But the […]",
    image: "http://i1.wp.com/venturebeat.com/wp-content/uploads/2015/11/seed-extensions.jpg?resize=160%2C140",
   pubdate: #<DateTime(4016-07-03T22:10:33Z)>,
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

````Elixir
# Scrape a feed and return only it's item urls:
Scrape.feed "http://example.com/feed", :minimal

# Result
["url1", "url2", ...]
````

## License

LGPLv3. Use this library however you want, but I want improvements & bugfixes
to flow back into this package.

# Future Development

As it turns out, Elixir is a *really* nice language to implement business logic
like this parser, and has served me quite well in the past. But CPU-intensive
tasks like scraping (parsing XML, analyzing strings/tokens, calculating stuff)
is definitely something where Elixir (and Erlang) has it's major weakness,
something that *can't* be fixed from within Elixir/Erlang.

The way to go for this problems is using NIFs
(**N**ative **I**mplemented **F**unctions) to offload CPU-intensive Tasks. In
the past this was done mostly in C/C++ for maximum performance, but there is
a huge gotcha: if your NIF has a bug (hint: most have) and segfaults at runtime,
it will crash your complete BEAM instance, rendering all of OTP and
fault-tolerance meaningless.

But here are the good news: there is now a systems programming language which is
as fast as C and is *safe*: Rust. Productive, fast, safe: pick three. Since
Rust has no GC or runtime, compiled libraries can be used from all major
programming languages, either through simple FFI or via native integrations.

So, I just started working on a complete scrape library written in Rust in
private, which will someday replace the core of this package completely. And
all my other public/private scraping modules, eg for node.js. This will reduce
all Elixir dependencies to zero, and the actual scrape "core" can benefit from
a combined effort from all programming languages out there that use my stuff.
This way all implementations also reap the benefits of being first-class and
have the best feature-set regardless of language strengths/weaknesses, since
they can all use the latest and best core written in Rust, which is extremely
fast, fault tolerant and type safe.

In the meantime, I upgraded floki which already supports html5ever as a
rust backend, which should give you a roughly 1x-5x performance improvement
depending on your scrape targets, but requires a rust compiler installed.

During this transition period I will accept PRs to fix bugs and other stuff and
I hope that library users are willing to pay the relativly small price of an
additional compiler hurdle to gain significant performance benefits. And over
time, once my core rust scraper is ready, it can take over all business logic
currently written in elixir under the hood, leading to *dramatic* improvements
in speed/quality/resilence/features.
