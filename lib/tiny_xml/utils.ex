defmodule TinyXml.Utils do
  @spec from_string(binary(), [{atom(), atom()}]) :: tuple()
  def from_string(xml_string, options \\ [quiet: true]) do
    {doc, []} =
      xml_string
      |> String.to_charlist()
      |> :xmerl_scan.string(options)

    doc
  end
end
