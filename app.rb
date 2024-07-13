require "sinatra"
require "sinatra/reloader"
require "sinatra/cookies"
require "http"

get("/") do
  redirect("/rate")
end

get("/rate") do
  @pic = JSON.parse(HTTP.get("https://api.thecatapi.com/v1/images/search"))[0]

  erb(:rate)
end

get("/history") do
  @history = JSON.parse(cookies["history"])

  erb(:history)
end

post("/display_rate") do
  @rating = params["value"]
  @url = params["url"]
  @id = params["id"]

  HTTP.post("https://api.thecatapi.com/v1/votes")

  new_history_entry = {
    :rating => @rating,
    :url => @url,
    :id => @id
  }

  if cookies["history"] == nil
    history = []
    history.push(new_history_entry)
    cookies["history"] = JSON.generate(history)
  else
    history = JSON.parse(cookies["history"])
    history.push(new_history_entry)
    cookies["history"] = JSON.generate(history)
  end

  erb(:display_rate)
end
