defmodule WebsiteWeb.ProjectLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <ul>
      <%= for repo <- assigns.repos do %>
        <li><%= repo.name %></li>
      <% end %>
    </ul>
    """
  end

  def mount(_params, _session, socket) do
    username = "txrunn"
    repos = get_repos(socket.assigns.username)
    {:ok, assign(socket, :repos, repos)}
  end

  defp get_repos(username) do
    url = "https://api.github.com/users/#{username}/repos/?sort=updated"
    headers = [{"Accept", "application/vnd.github+json"}]
    response = HTTPoison.get(url, headers)

    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> Enum.map(fn repo -> %{name: repo["name"]} end)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        []

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
        []
    end

    response
  end

end
