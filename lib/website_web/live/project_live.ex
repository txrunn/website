defmodule WebsiteWeb.ProjectLive do
  use Phoenix.LiveView

  @impl true
  def mount(_params, _session, socket) do
    {:ok, repos} = fetch_repos()
    {:ok, assign(socket, :repos, repos)}
  end

  def handle_event("refresh", _seession, socket) do
    case fetch_repos() do
      {:ok, repos} -> {:noreply, assign(socket, :repos, repos)}
      {:error, _session} -> {:noreply, socket}
    end
  end

  defp fetch_repos() do
    url = "https://api.github.com/users/txrunn/repos?sort=updated&direction=desc"
    headers = [{"User-Agent", "website"}]

    case HTTPoison.get(url, headers) do
      {:ok, %{status_code: 200, body: body}} ->
        repos = Jason.decode!(body)
        {:ok, repos}
      {:error, reason} ->
        {:error, reason}
      _ ->
        {:error, "Unknown error"}
    end
  end
end
