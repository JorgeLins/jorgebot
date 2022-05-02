defmodule Jorgebot.Consumer do


    use Nostrum.Consumer
    alias Nostrum.Api

    def start_link do
        Consumer.start_link(__MODULE__)
    end

    def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do

        # user = msg.author.username

        cond  do

            String.starts_with?(msg.content, "!tempo ") -> handleWeather(msg)

            msg.content ==  "!tempo" -> Api.create_message(msg.channel_id, "Use **!tempo <nome-da-cidade>**")

            msg.content ==  "!cachorro" -> handleDog(msg)

            msg.content == "!kanye" -> handleKanye(msg)

            msg.content == "!github " -> handleGit(msg)

            String.starts_with?(msg.content, "!") -> Api.create_message(msg.channel_id, "Comando não encontrado, tenta de novo")

            true -> :ignore
        end
    end

    def handle_event(_event) do
        :noop
    end

    defp handleDog(msg) do
        resp = HTTPoison.get!("https://dog.ceo/api/breeds/image/random")

        {:ok, map} = Poison.decode(resp.body)

        
        cat = map["message"]

        Api.create_message(msg.channel_id, "#{cat}")

    end

    defp handleKanye(msg) do
        resp = HTTPoison.get!("https://api.kanye.rest")

        {:ok, map} = Poison.decode(resp.body)

        
        kanye = map["quote"]

        Api.create_message(msg.channel_id, "**kanye once said:** #{kanye}")
    end

    defp handleGit(msg) do
        aux = String.split(msg.content, " ", parts: 2)
        username = Enum.fetch!(aux, 1)

        resp = HTTPoison.get!("https://github-readme-stats.vercel.app/api?username=#{username}&show_icons=true&theme=radical")

        {:ok, map} = Poison.decode(resp.body)

        
        git = map
        Api.create_message(msg.channel_id, "#{aux}")

    end

    defp handleWeather(msg) do
        aux = String.split(msg.content, " ", parts: 2)
        cidade = Enum.fetch!(aux, 1)

        resp = HTTPoison.get!("https://api.openweathermap.org/data/2.5/weather?q=#{cidade}&appid=d30cae19717053e998e8ddad3a568bcd&units=metric&lang=pt_br")

        {:ok, map} = Poison.decode(resp.body)
        

        case map["cod"] do
            200 ->
                temp = map["main"]["temp"]
                Api.create_message(msg.channel_id, "a temperatura da #{cidade} é de #{temp}°C")

            "404" ->
                Api.create_message(msg.channel_id, "Cidade não encontrada, tenta de novo")
        end
    end
end
