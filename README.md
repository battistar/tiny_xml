# TinyXml

![CI](https://github.com/Battistar/tiny_xml/actions/workflows/ci.yml/badge.svg) [![Coverage Status](https://coveralls.io/repos/github/Battistar/tiny_xml/badge.svg?branch=main)](https://coveralls.io/github/Battistar/tiny_xml?branch=main)

A tiny XML handler build on Erlang xmerl. TinyXml allows to validate, navigate and extract values and attributes from an XML data.

## Installation

The package can be installed by adding `tiny_xml` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tiny_xml, git: "https://github.com/battistar/tiny_xml", tag: "xxx"}
  ]
end
```

## Usage

Assume to use this XML for the following examples:

```xml
<shiporder orderid="889923">
  <orderperson>John Smith</orderperson>
  <shipto>
    <name>Ola Nordmann</name>
    <address>Langgt 23</address>
    <city>4000 Stavanger</city>
    <country>Norway</country>
  </shipto>
  <item>
    <title>Empire Burlesque</title>
    <note>Special Edition</note>
    <quantity>1</quantity>
    <price>10.90</price>
  </item>
  <item>
    <title>Hide your heart</title>
    <quantity>1</quantity>
    <price>9.90</price>
  </item>
</shiporder>
```

### Data extraction

To access to the first tag, described by an XPath expression, use `first` function. Then extract the value by `text` function:

```elixir
def extract_value(xml) do
  xml
  |> TinyXml.first("/shiporder/shipto/country")
  |> TinyXml.text()

  #=> "Norway"
end
```

To access to XML tag list use `all` function:

```elixir
def extract_list(xml) do
  xml
  |> TinyXml.all("/shiporder/item")
  |> Enum.map(fn xml_node -> 
    xml_node
    |> TinyXml.first("/item/price")
    |> TinyXml.text()
  end)

  #=> ["10.90", "9.90"]
end
```

Use the function `attribute` to get an XML tag attribute:

```elixir
def extract_attribute(xml) do
  xml
  |> TinyXml.first("/shiporder")
  |> TinyXml.attribute("orderid")

  #=> "889923"
end
```

### Validation

An XML file or string can be validate against an XML schema:

```elixir
def validate_file_data(xml_file_path) do
  TinyXml.Schema.validate_file(xml_file_path, "path/to/schema")

  #=> :ok
end

def validate_string_data(xml_string) do
  TinyXml.Schema.validate_string(xml_string, "path/to/schema")

  #=> {:error, _reason}
end
```
