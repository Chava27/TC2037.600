#Program that takes in a json files and returns an htm for syntax highlighting
#
#
#


defmodule Syntax do
  def json_to_hmtl(in_filename, out_filename) do
    template = File.read("template.html")
    tokens =
      in_filename
      |> Enum.stream!() #genera lista de renglones
      |> Enum.map()
      |> Enum.joint("\n")
    File.write(out_filename,tokens)
  end

  def token?(line) do

  end
end
