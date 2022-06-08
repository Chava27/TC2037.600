# Program that takes in a json files and returns an htm for syntax highlighting
# Actividad Integradora 3.4 Resaltador de sintaxis (evidencia de competencia)
# Salvador Salgado Normandia
# Luis Javier Karam Galland
# --------------------------------------------------List of REGEX used--------------------------------------------------
# REGEX for KEYS:(?=^)\t* *"[\w0-9:-]+" *(?=:)
# REGEX for VALUES (String):(?!.*:)(?=^) *"[\(\)\;a-zA-z0-9#.&': ?@+!=\/.\*,-]*"| *"[\(\)\;a-zA-z0-9.&': ?@+!#=\/.\*,-]*"(?=[,}\]]+)|""
# REGEX for punctuation:(?=^) *[{},:\[\]]+
# REGEX for reserved words:(?!.*\d)(?=^)(?=(?:[^"]*"[^"]*")*[^"]*\Z) *[a-zA-Z]+
# REGEX for numbers:(?=(?:[^"]*"[^"]*")*[^"]*\Z)(?=^) *[\d+E.-]



defmodule Syntax do
  def json_to_html(in_filename, out_filename) do
    d = Date.utc_today()
    template_1 = File.read!("template_1.html")
    #Add date inside the html template
    |> String.replace("\#\{datetime\}",Date.to_string(d))
    template_2 = File.read!("template_2.html")
    tokens =
      in_filename
      |> File.stream!() #genera lista de renglones
      |> Enum.map(&token/1)
      |> Enum.join("\n")
    #Once the html is created we join it whith our template_1 (beginning of html)
    file1 = Enum.join([template_1,tokens])
    #Add end of html
    file2 = Enum.join([file1,template_2])
    File.write(out_filename,file2)
  end

  def token(line), do: token(String.replace(line,"\n",""),"")
  defp token(line,result) when line == "" or line == "\n", do: result
  defp token(line, result) do
    cond do
      #If token is punctuation
      Regex.match?(~r/(?=^) *[{},:\[\]]+/, line) -> js_html(line, "p", result)
      #If token found is a key with the following two points
      Regex.match?(~r/(?=^)\t* *"[\w0-9:-]+" *(?=:)/, line) -> js_html(line, "k", result)
      #If token found is a string value
      Regex.match?(~r/(?!.*:)(?=^) *"[\(\)\;a-zA-z0-9#.&': ?@+!=\/.\*,-]*"| *"[\(\)\;a-zA-z0-9.&': ?@+!#=\/.\*,-]*"(?=[,}\]]+)|""/,line)-> js_html(line, "s", result)
      #If token found is a reserved words
      Regex.match?(~r/(?!.*\d)(?=^)(?=(?:[^"]*"[^"]*")*[^"]*\Z) *[a-zA-Z]+/, line) -> js_html(line, "r", result)
      #If token found is a number
      Regex.match?(~r/(?=(?:[^"]*"[^"]*")*[^"]*\Z)(?=^) *[\d+E.-]/, line) -> js_html(line, "n", result)
      true -> IO.puts "FAILED TO DETECT #{line}"
    end
  end



  def js_html(line, type, result) do
    cond do
      type == "k" ->
        [token]=Regex.run(~r/(?=^)\t* *"[\w0-9:-]+" *(?=:)/,line)
        #create html with the corresponding key and punctuation <span clas="object-key"{key}>
        html_text= "<span class='object-key'>#{token}</span>"
        #call function with new values
        token(String.replace(line,~r/(?=^)\t* *"[\w0-9:-]+" *(?=:)/,""),Enum.join([result,html_text]))
      type == "p" ->
        [token]=Regex.run(~r/(?=^) *[{},:\[\]]+/, line)
        #create html with the punctuation
        html_text= "<span class='punctuation'>#{token}</span>"
        #call function with new values
        token(String.replace(line,~r/(?=^) *[{},:\[\]]+/,""), Enum.join([result,html_text]))
      type == "s" ->
        [token]=Regex.run(~r/(?!.*:)(?=^) *"[\(\)\;a-zA-z0-9#.&': ?@+!=\/.\*,-]*"| *"[\(\)\;a-zA-z0-9.&': ?@+!#=\/.\*,-]*"(?=[,}\]]+)|""/, line)
        #create html with the punctuation
        html_text= "<span class='string'>#{token}</span>"
        #call function with new values
        token(String.replace(line,~r/(?!.*:)(?=^) *"[\(\)\;a-zA-z0-9#.&': ?@+!=\/.\*,-]*"| *"[\(\)\;a-zA-z0-9.&': ?@+!#=\/.\*,-]*"(?=[,}\]]+)|""/,""),Enum.join([result,html_text]))
      type == "r" ->
        [token]=Regex.run(~r/(?!.*\d)(?=^)(?=(?:[^"]*"[^"]*")*[^"]*\Z) *[a-zA-Z]+/, line)
        #create html with the punctuation
        html_text= "<span class='reserved-word'>#{token}</span>"
        #call function with new values
        token(String.replace(line,~r/(?!.*\d)(?=^)(?=(?:[^"]*"[^"]*")*[^"]*\Z) *[a-zA-Z]+/,""),Enum.join([result,html_text]))
      type == "n" ->
        [token]=Regex.run(~r/(?=(?:[^"]*"[^"]*")*[^"]*\Z)(?=^) *[\d+E.-]/, line)
        #create html with the punctuation
        html_text= "<span class='number'>#{token}</span>"
        #call function with new values
        token(String.replace(line,~r/(?=(?:[^"]*"[^"]*")*[^"]*\Z)(?=^) *[\d+E.-]/,""),Enum.join([result,html_text]))

      true -> IO.puts "Failed to detect token"
    end
  end
#multi_json_to_html recibe como parametro la dirección de un directorio que contiene varios archivos json. Una vez 
  def multi_json_to_html(file_dir) do
    IO.puts "Main thread START"
    Path.wildcard("#{file_dir}/*.json")
    |> Enum.map(&Task.start(fn -> json_to_html(&1, "#{&1}.html") end))
    IO.puts "Main thread FINISH"
  end

  def single_json_to_html(file_dir) do
    IO.puts "Main thread START"
    Path.wildcard("#{file_dir}/*.json")
    |> Enum.map(&json_to_html(&1, "#{&1}.html"))
    IO.puts "Main thread FINISH"
  end

  def meassure_time(function) do
    function
    |> :timer.tc()
    |> elem(0)
    |> Kernel./(1_000_000)
    |> IO.inspect()
  end
end
