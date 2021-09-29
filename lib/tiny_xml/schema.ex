defmodule TinyXml.Schema do
  import TinyXml.Utils, only: [from_string: 1]

  @spec validate(binary, binary) :: :ok | {:error, [tuple()]}
  def validate(xml_string, schema_path) do
    xml_data = from_string(xml_string)
    schema_path = to_charlist(schema_path)

    {:ok, schema} = :xmerl_xsd.process_schema(schema_path)

    case :xmerl_xsd.validate(xml_data, schema) do
      {:error, reason} -> {:error, reason}
      _ -> :ok
    end
  end
end
