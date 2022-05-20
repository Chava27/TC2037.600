# Program that takes in a json files and returns an htm for syntax highlighting
#
#
#
# --------------------------------------------------List of REGEX used--------------------------------------------------
# REGEX for KEYS:(?=^)\t* *"[\w0-9:-]+" *(?=:)
# REGEX for VALUES (String):(?!.*:)(?=^) *"[\(\)\;a-zA-z0-9.&': ?@+!=\/.\*,-]+"| *"[\(\)\;a-zA-z0-9.&': ?@+!=\/.\*,-]+"(?=,)
# REGEX for punctuation:(?=^) *[{},:\[\]]+
# REGEX for reserved words:(?!.*\d)(?=^)(?=(?:[^"]*"[^"]*")*[^"]*\Z) *[a-zA-Z]
# REGEX for numbers:(?=(?:[^"]*"[^"]*")*[^"]*\Z)(?=^) *[\d+E.-]



defmodule Syntax do
  def json_to_html(in_filename, out_filename) do
    d = DateTime.utc_now
    template_1 = File.read!("template_1.html")
    |> String.replace("\#\{datetime\}",DateTime.to_string(d))
    template_2 = File.read!("template_2.html")
    tokens =
      in_filename
      |> File.stream!() #genera lista de renglones
      |> Enum.map(&token/1)
      |> Enum.join("\n")
    IO.puts "FINISHED PROCCESING FILE"
    IO.puts(tokens)
    IO.puts(template_1)
    file1 = Enum.join([template_1,tokens])
    file2 = Enum.join([file1,template_2])
    IO.puts file2
    File.write(out_filename,file2)
  end

  def token(line), do: token(String.replace(line,"\n",""),"")
  defp token(line,result) when line == "" or line == "\n", do: result
  defp token(line, result) do
    IO.puts "RESULT: #{result}"
    IO.puts "new line: #{line}"
    cond do
      #If token is punctuation
      Regex.match?(~r/(?=^) *[{},:\[\]]+/, line) -> js_html(line, "p", result)
      #If token found is a key with the following two points
      Regex.match?(~r/(?=^)\t* *"[\w0-9:-]+" *(?=:)/, line) -> js_html(line, "k", result)
      #If token found is a string value
      Regex.match?(~r/(?!.*:)(?=^) *"[\(\)\;a-zA-z0-9.&': ?@+!=\/.\*,-]+"| *"[\(\)\;a-zA-z0-9.&': ?@+!=\/.\*,-]+"(?=,)/,line)-> js_html(line, "s", result)
      #If token found is a reserved words
      Regex.match?(~r/(?!.*\d)(?=^)(?=(?:[^"]*"[^"]*")*[^"]*\Z) *[a-zA-Z]/, line) -> js_html(line, "r", result)
      #If token found is a number
      Regex.match?(~r/(?=(?:[^"]*"[^"]*")*[^"]*\Z)(?=^) *[\d+E.-]/, line) -> js_html(line, "n", result)
      true -> IO.puts "FAILED TO DETECT #{line}"
    end
  end



  def js_html(line, type, result) do
    IO.puts type
    cond do
      type == "k" ->
        [token]=Regex.run(~r/(?=^)\t* *"[\w0-9:-]+" *(?=:)/,line)
        IO.puts token
        #create html with the corresponding key and punctuation <span clas="object-key"{key}>
        html_text= "<span class='object-key'>#{token}</span>"
        #call function with new values
        token(String.replace(line,~r/(?=^)\t* *"[\w0-9:-]+" *(?=:)/,""),Enum.join([result,html_text]))
      type == "p" ->
        [token]=Regex.run(~r/(?=^) *[{},:\[\]]+/, line)
        IO.puts token
        #create html with the punctuation
        html_text= "<span class='punctuation'>#{token}</span>"
        #call function with new values
        token(String.replace(line,~r/(?=^) *[{},:\[\]]+/,""), Enum.join([result,html_text]))
      type == "s" ->
        [token]=Regex.run(~r/(?!.*:)(?=^) *"[\(\)\;a-zA-z0-9.&': ?@+!=\/.\*,-]+"| *"[\(\)\;a-zA-z0-9.&': ?@+!=\/.\*,-]+"(?=,)/, line)
        IO.puts token
        #create html with the punctuation
        html_text= "<span class='string'>#{token}</span>"
        #call function with new values
        token(String.replace(line,~r/(?!.*:)(?=^) *"[\(\)\;a-zA-z0-9.&': ?@+!=\/.\*,-]+"| *"[\(\)\;a-zA-z0-9.&': ?@+!=\/.\*,-]+"(?=,)/,""),Enum.join([result,html_text]))
      type == "r" ->
        [token]=Regex.run(~r/(?!.*\d)(?=^)(?=(?:[^"]*"[^"]*")*[^"]*\Z) *[a-zA-Z]/, line)
        IO.puts token
        #create html with the punctuation
        html_text= "<span class='reserved-word'>#{token}</spann"
        #call function with new values
        token(String.replace(line,~r/(?!.*\d)(?=^)(?=(?:[^"]*"[^"]*")*[^"]*\Z) *[a-zA-Z]/,""),Enum.join([result,html_text]))
      type == "n" ->
        [token]=Regex.run(~r/(?=(?:[^"]*"[^"]*")*[^"]*\Z)(?=^) *[\d+E.-]/, line)
        IO.puts token
        #create html with the punctuation
        html_text= "<span class='number'>#{token}</span>"
        #call function with new values
        token(String.replace(line,~r/(?=(?:[^"]*"[^"]*")*[^"]*\Z)(?=^) *[\d+E.-]/,""),Enum.join([result,html_text]))

      true -> IO.puts "Failed to detect token"
    end
  end
end
