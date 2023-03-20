defmodule WebsiteWeb.ProjectLive do
  use Phoenix.LiveView

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket} = fetch_projects(socket)
    {:ok, socket}
  end

  def handle_event("refresh", _, socket) do
    {:noreply, fetch_projects(socket)}
  end

  def fetch_projects(socket) do
    url = "https://api.github.com/users/txrunn/repos"
    headers = [{"User-Agent", "website"}]
    case HTTPoison.get(url, headers) do
      {:ok, %{status_code: 200, body: body}} ->
        projects = Jason.decode!(body)
        {:ok, assign(socket, :projects, projects)}
      _ ->
        {:ok, socket}
    end
  end
  
  def render(assigns) do
    ~L"""
    <ul>
      <%= for project <- @projects do %>
        <li><%= project["name"] %></li>
      <% end %>
    </ul>
    <button phx-click="refresh">Refresh</button>
    """
  end
end