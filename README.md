# Xray

Xray is an academic exploration of strings and encodings in [Elixir](https://elixir-lang.org/). 

It offers utility functions useful for inspecting strings and their code points. 

For example, the `Xray.inspect/1` function:

```elixir
iex> Xray.inspect("cät")
    ======================================================
    Input String: cät
    Character Count: 3
    Byte Count: 4
    Is valid? true
    Is printable? true
    ======================================================

    c   Codepoint: 99 (\\u0063) https://codepoints.net/U+0063
      Is printable? true
      Script(s): latin
      Byte Count: 1
      UTF-8: <<99>>
      Base2: 01100011

    ä   Codepoint: 228 (\\u00E4) https://codepoints.net/U+00E4
      Is printable? true
      Script(s): latin
      Byte Count: 2
      UTF-8: <<195, 164>>
      Base2: 11000011 10100100

    t   Codepoint: 116 (\\u0074) https://codepoints.net/U+0074
      Is printable? true
      Script(s): latin
      Byte Count: 1
      UTF-8: <<116>>
      Base2: 01110100
    [:ok, :ok, :ok]
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `xray` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:xray, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/xray](https://hexdocs.pm/xray).

## On Codepoints vs Graphemes

```elixir
iex> String.codepoints("🇺🇸")
["🇺", "🇸"]
iex> String.split("🇺🇸", "", trim: true)
["🇺🇸"]
iex> "🇺🇸" <><<0>>
<<240, 159, 135, 186, 240, 159, 135, 184, 0>>
```

## See Also

Some interesting articles
- https://angelika.me/2017/07/11/print-my-string-elixir/
- https://elixirforum.com/t/where-did-the-name-binaries-come-from-and-how-does-this-relate-to-base2/29490/14