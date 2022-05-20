# Program that takes in a json files and returns an htm for syntax highlighting
#
#
#
# --------------------------------------------------List of REGEX used--------------------------------------------------
# REGEX for KEYS:(?=^) *"[\w0-9:-]+"(?=:)
# REGEX for VALUES (String):(?!.*:)(?=^) *"[\(\)\;a-zA-z0-9.&': ?@+!=\/.\*,-]+"| *"[\(\)\;a-zA-z0-9.&': ?@+!=\/.\*,-]+"(?=,)
# REGEX for punctuation:(?=^) *[{},:\[\]]+
# REGEX for reserved words:(?!.*\d)(?=^)(?=(?:[^"]*"[^"]*")*[^"]*\Z) *[a-zA-Z]
# REGEX for numbers:(?=(?:[^"]*"[^"]*")*[^"]*\Z)(?=^) *[\d+E.-]



defmodule Syntax do
  def json_to_hmtl(in_filename, out_filename) do
    template = File.read("template.html")
    tokens =
      in_filename
      |> File.stream!() #genera lista de renglones
      |> Enum.map(&token/1)
      |> Enum.join("\n")
    File.write(out_filename,tokens)
  end

  def token(line), do: token(line,"")
  defp token(line,result) when line == "", do: result
  defp token(line, result) do
    cond do
      #If token is punctuation
      Regex.match?(~r/(?=^) *[{},:\[\]]+/, line) -> js_html(line, "p", result)
      #If token found is a key with the following two points
      Regex.match?(~r/(?=^) *"[\w0-9:-]+"(?=:)/, line) -> js_html(line, "k", result)
      #If token found is a string value
      Regex.match?(~r/(?!.*:)(?=^) *"[\(\)\;a-zA-z0-9.&': ?@+!=\/.\*,-]+"| *"[\(\)\;a-zA-z0-9.&': ?@+!=\/.\*,-]+"(?=,)/,line)-> js_html(line, "s", result)
      #If token found is a reserved words
      Regex.match?(~r/(?!.*\d)(?=^)(?=(?:[^"]*"[^"]*")*[^"]*\Z) *[a-zA-Z]/, line) -> js_html(line, "r", result)
      #If token found is a number
      Regex.match?(~r/(?=(?:[^"]*"[^"]*")*[^"]*\Z)(?=^) *[\d+E.-]/, line) -> js_html(line, "n", result)
    end
  end



  def js_html(line, type, result) do
    cond do
      type == "k" ->
        [token]=Regex.run(~r/(?=^) *"[\w0-9:-]+"(?=:)/,line)
        #create html with the corresponding key and punctuation <span clas="object-key"{key}>
        html_text= "<span class='object-key'>#{token}</span>\n"
        #call function with new values
        token(String.replace(line,~r/(?=^) *"[\w0-9:-]+"(?=:)/,""),Enum.join([result,html_text]))
      type == "p" ->
        [token]=Regex.run(~r/(?=^) *[{},:\[\]]+/, line)
        #create html with the punctuation
        html_text= "<span class='punctuation'>#{token}</span>\n"
        #call function with new values
        token(String.replace(line,~r/(?!.*:)(?=^) *"[\(\)\;a-zA-z0-9.&': ?@+!=\/.\*,-]+"| *"[\(\)\;a-zA-z0-9.&': ?@+!=\/.\*,-]+"(?=,)/,""), Enum.join([result,html_text]))
      type == "s" ->
        [token]=Regex.run(~r/([{},:\[\]]+)/, line)
        #create html with the punctuation
        html_text= "<span class='string'>#{token}</span>\n"
        #call function with new values
        token(String.replace(line,~r/( *"\w+" *(?=:))(:)/,""),Enum.join([result,html_text]))
      type == "r" ->
        [token]=Regex.run(~r/([{},:\[\]]+)/, line)
        #create html with the punctuation
        html_text= "<span class='reserved-word'>#{token}</span>\n"
        #call function with new values
        token(String.replace(line,~r/( *"\w+" *(?=:))(:)/,""),Enum.join([result,html_text]))
      type == "n" ->
        [token]=Regex.run(~r/([{},:\[\]]+)/, line)
        #create html with the punctuation
        html_text= "<span class='number'>#{token}</span>\n"
        #call function with new values
        token(String.replace(line,~r/( *"\w+" *(?=:))(:)/,""),Enum.join([result,html_text]))
    end
  end
end
