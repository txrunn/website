defmodule WebsiteWeb.ProjectLive do
  use Phoenix.LiveView

  @impl true
  def mount(_params, _session, socket) do
    {:ok, repos} = fetch_repos()
    assign(socket, :repos, repos)
  end

  def handle_event("refresh", _, socket) do
    case fetch_repos() do
      {:ok, repos} -> {:noreply, assign(socket, :repos, repos)}
      {:error, _} -> {:noreply, socket}
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

  defp render_repo(repo) do
    """
    <div class="repo-card">
      <a href="#{repo["html_url"]}" target="_blank" class="repo-link">#{repo["name"]}</a>
      <p>#{repo["description"] || ""}</p>
    </div>
    """
  end

  def render(assigns) do
    """
    <div class="repos-grid">
      #{for repo <- assigns.repos, do: render_repo(repo)}
    </div>
    """
  end
end
