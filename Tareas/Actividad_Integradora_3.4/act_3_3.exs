#Program that takes in a json files and returns an htm for syntax highlighting
#
#Value; ((?<=:) *[*"\(\)\;*[a-zA-z0-9.&': ?+!=\/.,-]+ *"]*)
#
# ("\w+" *:)                   "movie":
# ((?<=:) *"[a-zA-z0-9.: ]+ *")     "Merian C. Cooper"
# ( *"\w+" *)(:)((?<=:) *"[a-zA-z0-9.: ]+ *")(,)
# ( *"\w+" *)(:)
# REGEX for key: "movie":
#"King Kong",
# {,},[,],:,,
# REGEX for symbols: ([{},:\[\]]+)
# REGEX for first bracket: (?=^) *[{},:\[\]]


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
      Regex.match?(~r/ *"\w+" *(?=:)/, line) -> js_html(line, "k", result)
      Regex.match?(~r/(?<=:) *"[a-zA-z0-9.: ]+ *"/,line)-> js_html(line, "s", result)
      Regex.match?(~r/[{},:\[\]]+/, line) -> js_html(line, "p", result)
    end


    [key,dots,value,comma] = Regex.run
    token()



   # "<span class = \"token\"> #{name} <\span>"

  end



  def js_html(line, type, result)
    cond do
      type == "k" ->
        [token,key,dot]=Regex.run(~r/( *"\w+" *(?=:))(:)/,line)
        #create html with the corresponding key and punctuation <span clas="object-key"{key}>
        #insert in html
        #delete info from list
        {trash,n_line}String.split_at(line,token)
        token(n_line,result)

      #key = "movie"
      #dot = :
      type == "p" -> [token]=Regex.run(~r/([{},:\[\]]+)/, line)
      type == "v"
    end


  end
