defmodule TinyXml do
  import TinyXml.Utils, only: [from_string: 1]

  require Record

  Record.defrecord(:xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl"))

  @spec all(binary(), binary()) :: [tuple()] | []
  def all(xml_string, path) when is_binary(xml_string) do
    xml_string
    |> from_string()
    |> all(path)
  end

  @spec all(tuple(), binary()) :: [tuple()] | []
  def all(xml_node, path), do: xpath(xml_node, path)

  @spec first(binary(), binary()) :: tuple() | nil
  def first(xml_string, path) when is_binary(xml_string) do
    xml_string
    |> from_string()
    |> first(path)
  end

  @spec first(tuple(), binary()) :: tuple() | nil
  def first(xml_node, path) do
    case xpath(xml_node, path) do
      [head | _] -> head
      _ -> nil
    end
  end

  @spec text(tuple()) :: binary() | nil
  def text(xml_node) do
    case xpath(xml_node, "./text()") do
      [xmlText(value: value)] -> to_string(value)
      _ -> nil
    end
  end

  @spec xpath(tuple() | nil, binary()) :: [tuple()] | []
  defp xpath(nil, _), do: []
  defp xpath(xml, path), do: :xmerl_xpath.string(to_charlist(path), xml)
end
