#Program that takes in a json files and returns an htm for syntax highlighting
#
#
#
# ("\w+" *:)                   "movie":
# (: *"[a-zA-z0-9.: ]+ *")     "Merian C. Cooper"
# ( *"\w+" *)(:)( *"[a-zA-z0-9.: ]+ *")(,)
# ( *"\w+" *)(:)
# REGEX for key: "movie":
#"King Kong",
# {,},[,],:,,
# REGEX for symbols: ([{},:\[\]]+)
# REGEX for { awkdakdw:: [{},:\[\]]+(?= *"\w+": *)


defmodule Syntax do
  def json_to_hmtl(in_filename, out_filename) do
    template = File.read("template.html")
    tokens =
      in_filename
      |> Enum.stream!() #genera lista de renglones
      |> Enum.map(&token/1)
      |> Enum.join("\n")
    File.write(out_filename,tokens)
  end

  def token(line), do: token(line,"")
  defp token(line,result) when line == "", do: result
  defp token(line, result) do
    cond do
      Regex.match?(~r/ *"\w+" *:/, line) -> js_html(line, "k", result)
      Regex.match?(~r/[{},:\[\]]+/, line) -> js_html(line, "p", result)
    end


    [key,dots,value,comma] = Regex.run
    token()



   # "<span class = \"token\"> #{name} <\span>"

  end



  def js_html(line, type, result)
    cond do
      type == "k" -> [token,key,dot]=Regex.run(~r/( *"\w+" *)(:)/,line)
      #key = "movie"
      #dot = ":"
      type == "p" -> [token]=Regex.run(~r/([{},:\[\]]+)/, line)
    end


  end
