defmodule TinyXml do
  import TinyXml.Utils, only: [from_string: 1]

  require Record

  Record.defrecord(:xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl"))

  Record.defrecord(
    :xmlAttribute,
    Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  )

  @doc """
  Giving an `xml_string` or `xml_node` and a `path` (XPath expression),
  returns a list of `xml_node` result of the XPath expression or an empty list.
  """
  @spec all(String.t(), String.t()) :: [tuple()] | []
  def all(xml_string, path) when is_binary(xml_string) do
    xml_string
    |> from_string()
    |> all(path)
  end

  @spec all(tuple(), String.t()) :: [tuple()] | []
  def all(xml_node, path), do: xpath(xml_node, path)

  @doc """
  Giving an `xml_string` or `xml_node` and a `path` (XPath expression),
  returns the first `xml_node` result of the XPath expression or `nil`.
  """
  @spec first(String.t(), String.t()) :: tuple() | nil
  def first(xml_string, path) when is_binary(xml_string) do
    xml_string
    |> from_string()
    |> first(path)
  end

  @spec first(tuple(), String.t()) :: tuple() | nil
  def first(xml_node, path) do
    case xpath(xml_node, path) do
      [head | _] -> head
      _ -> nil
    end
  end

  @doc """
  Extracts value from `xml_node`. If value doesn't exists returns `nil`.

    ## Examples
      xml = "
        <Person>
          <Name>Max</Name>
          <Surname>Power</Surname>
        </Person>
      "

      xml
      |> TinyXml.first("/Person/Name")
      |> TinyXml.text()
      #=> "Max"

      xml
      |> TinyXml.first("/Person/Name/invalid")
      |> TinyXml.text()
      #=> nil
  """
  @spec text(tuple()) :: String.t() | nil
  def text(xml_node) do
    case xpath(xml_node, "./text()") do
      [xmlText(value: value)] -> to_string(value)
      _ -> nil
    end
  end

  @doc """
  Extracts attribute from `xml_node`. If attribute doesn't exists returns `nil`.

    ## Examples
      xml = "
        <Person id="123">
          <Name>Max</Name>
          <Surname>Power</Surname>
        </Person>
      "

      xml
      |> TinyXml.first("/Person")
      |> TinyXml.attribute()
      #=> "123"

      xml
      |> TinyXml.first("/Person/invalid")
      |> TinyXml.attribute()
      #=> nil
  """
  @spec attribute(tuple(), String.t()) :: String.t() | nil
  def attribute(xml_node, attribute) do
    case xpath(xml_node, "./@#{attribute}") do
      [xmlAttribute(value: value)] -> to_string(value)
      _ -> nil
    end
  end

  @spec xpath(tuple() | nil, String.t()) :: [tuple()] | []
  defp xpath(nil, _), do: []
  defp xpath(xml, path), do: :xmerl_xpath.string(to_charlist(path), xml)
end
