defmodule Xray do
  @moduledoc """
  Xray offers utility functions for inspecting string binaries, their
  code points, and their base2 representations.

  This package was the result of my own studying of Elixir strings and binaries.
  It's unlikely you would actually use this as a dependency, but I offer it up
  for public use in the hopes that it may be educational.
  """

  @doc """
  This function prints a report on the provided input string. This may not work
  especially well when the input contains non-printable characters (YMMV).

  For each character in the string, the following information is shown:

  - code point as a decimal, e.g. `228`
  - code point in its Elixir Unicode representation, e.g. `\\u00E4`
  - a link to a page containing more information about this Unicode code point
  - count of the number of bytes required to represent this code point using UTF-8 encoding
  - an inspection of the UTF-8 binaries, e.g. `<<195, 164>>`
  - a `Base2` representation (i.e. 1's and 0's) of the encoded code point

  The `Base2` representation (what we would be tempted to call the "binary" representation)
  highlights control bits in red to help show how [UTF-8](https://en.wikipedia.org/wiki/UTF-8)
  identifies how many bytes are required to encode each character.

  ## Examples
    ```
    iex> Xray.inspect("cät")
    ======================================================
    Input String: cät
    Character Count: 3
    Byte Count: 4
    ======================================================

    c   Codepoint: 99 (\\u0063) https://codepoints.net/U+0063
        Script(s): latin
        Byte Count: 1
        UTF-8: <<99>>
        Base2: 01100011

    ä   Codepoint: 228 (\\u00E4) https://codepoints.net/U+00E4
        Script(s): latin
        Byte Count: 2
        UTF-8: <<195, 164>>
        Base2: 11000011 10100100

    t   Codepoint: 116 (\\u0074) https://codepoints.net/U+0074
        Script(s): latin
        Byte Count: 1
        UTF-8: <<116>>
        Base2: 01110100
    ```
  """
  @spec inspect(value :: binary) :: String.t
  def inspect(value) when is_binary(value) do
    value
    |> heading()
    |> String.split("", trim: true)
    |> Enum.map(&character_profile/1)
  end

  # This headlines the `inspect/1` output.
  defp heading(value) do
    IO.puts("======================================================")
    IO.puts("Input String: #{value}")
    IO.puts("Character Count: #{String.length(value)}")
    IO.puts("Byte Count: #{byte_size(value)}")
    IO.puts("======================================================")
    value
  end

  # This is our formatting card for displaying info about a single character
  defp character_profile(x) do
    IO.puts("")

    IO.puts(
      character_heading(x) <>
        "   Codepoint: #{codepoint(x)} (\\u#{codepoint(x, as_hex: true)}) #{link(x)}"
    )

    IO.puts(indent("Script(s): #{Enum.join(Unicode.script(x), ",")}"))
    IO.puts(indent("Byte Count: #{byte_size(x)}"))
    IO.inspect(x, binaries: :as_binaries, label: "    UTF-8")
    IO.puts(indent("Base2: " <> to_base2(x)))
  end

  defp character_heading(x) do
    IO.ANSI.bright() <> x <> IO.ANSI.reset()
  end

  @doc """
  Reveals the integer codepoint for the given single character; when run with
  the default options, this is equivalent to the question-mark operator, e.g.
  `?x` but this function works with variables (whereas the question mark only
  evaluates literal characters).

  ## Options:

  ### `:as_hex` (boolean) default: `false`

  When true, returns the hexidecimal representation of the codepoint number. The
  hexidecimal representation is useful when looking up documentation, e.g. on
  [Wikipedia](https://en.wikipedia.org/wiki/List_of_Unicode_characters) or on
  websites like [codepoints.net](https://codepoints.net/).

  ## Examples
      iex> codepoint("ä")
      228
      iex> codepoint("ä", as_hex: true)
      "00E4"
  """
  @spec codepoint(binary, opts :: keyword) :: integer | String.t()
  def codepoint(<<codepoint::utf8>>, opts \\ []) do
    case Keyword.get(opts, :as_hex) do
      true -> codepoint_as_hex(codepoint)
      _ -> codepoint
    end
  end

  @doc """
  Given a string binary, this returns a list of the codepoints that represent
  each of the characters in the string. This is what you might expect
  `String.codepoints/1` to return, but instead of returning a list of the
  component *characters* like `String.codepoints/1` does, this function
  returns the *numbers* (which is what code points are).

  ## Options
    - `:as_hex` (see `codepoint/2`)

  ## Examples
      iex> Xray.codepoints("cät")
      [99, 228, 116]
  """
  @spec codepoints(string :: binary, opts :: keyword) :: list
  def codepoints(string, opts \\ []) when is_binary(string) do
    string
    |> String.split("", trim: true)
    |> Enum.reduce([], fn x, acc -> [codepoint(x, opts) | acc] end)
    |> Enum.reverse()
  end

  # Converts a character like ä to its hexidecimal representation like `00E4`
  defp codepoint_as_hex(codepoint) do
    list = Integer.to_charlist(codepoint, 16)
    String.pad_leading(to_string(list), 4, ["0"])
  end

  # Simple indentation
  defp indent(string) do
    "    " <> string
  end

  # get a link to some official documentation about this codepoint
  # e.g. https://codepoints.net/U+00E4
  defp link(<<codepoint::utf8>>) do
    slug = "U+#{codepoint_as_hex(codepoint)}"
    IO.ANSI.blue() <> "https://codepoints.net/#{slug}" <> IO.ANSI.reset()
  end

  defp to_base2(x) do
    base2 = Base2.encode2(x, padding: :all)
    parse_bytes(base2, "") <> IO.ANSI.reset()
  end

  # Some nice formatting of the base2 representation highlighting the control bits that
  # flag multi-byte characters in UTF-8.
  # Start of 4-byte encoding of codepoint
  defp parse_bytes("11110" <> <<byte_rest::binary-size(3), other_bytes::binary>>, acc) do
    parse_bytes(
      other_bytes,
      acc <> IO.ANSI.red() <> "11110" <> IO.ANSI.green() <> byte_rest <> " "
    )
  end

  # Start of 3-byte encoding of codepoint
  defp parse_bytes("1110" <> <<byte_rest::binary-size(4), other_bytes::binary>>, acc) do
    parse_bytes(
      other_bytes,
      acc <> IO.ANSI.red() <> "1110" <> IO.ANSI.green() <> byte_rest <> " "
    )
  end

  # Start of 2-byte encoding of codepoint
  defp parse_bytes("110" <> <<byte_rest::binary-size(5), other_bytes::binary>>, acc) do
    parse_bytes(other_bytes, acc <> IO.ANSI.red() <> "110" <> IO.ANSI.green() <> byte_rest <> " ")
  end

  # Start of secondary byte
  defp parse_bytes("10" <> <<byte_rest::binary-size(6), other_bytes::binary>>, acc) do
    parse_bytes(other_bytes, acc <> IO.ANSI.red() <> "10" <> IO.ANSI.green() <> byte_rest <> " ")
  end

  # Start of a single byte codepoint
  defp parse_bytes("0" <> <<byte_rest::binary-size(7), other_bytes::binary>>, acc) do
    parse_bytes(other_bytes, acc <> IO.ANSI.red() <> "0" <> IO.ANSI.green() <> byte_rest <> " ")
  end

  # All done!
  defp parse_bytes("", acc), do: acc
end
