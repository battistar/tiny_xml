defmodule TinyXml.Schema do
  @moduledoc """
  XML schema utility functions.
  """

  import TinyXml.Utils, only: [from_string: 1]

  @doc """
  Validates the `xml_string` trought the XML schema file at `schema_path`.

  Returns `:ok` if XML is valid otherwise `{:error, reason}`.

    ## Examples
      xml = "
        <Person>
          <Name>Max</Name>
          <Surname>Power</Surname>
        </Person>
      "

      TinyXml.Schema.validate_string(xml, "path/to/schema.xsd")
      #=> :ok
  """
  @spec validate_string(String.t(), Path.t()) :: :ok | {:error, [tuple()]}
  def validate_string(xml_string, schema_path) do
    xml_data = from_string(xml_string)
    schema_path = to_charlist(schema_path)

    {:ok, schema} = :xmerl_xsd.process_schema(schema_path)

    case :xmerl_xsd.validate(xml_data, schema) do
      {:error, reason} -> {:error, reason}
      _ -> :ok
    end
  end

  @doc """
  Validates an XML file at `xml_path` trought the XML schema file at `schema_path`.

  Returns `:ok` if XML is valid otherwise `{:error, reason}`.

    ## Examples
      TinyXml.Schema.validate_file("path/to/file.xml", "path/to/schema.xsd")
      #=> :ok
  """
  @spec validate_file(Path.t(), Path.t()) :: :ok | {:error, [tuple()]}
  def validate_file(xml_path, schema_path) do
    case File.read(xml_path) do
      {:ok, xml_string} -> validate_string(xml_string, schema_path)
      err -> err
    end
  end
end
