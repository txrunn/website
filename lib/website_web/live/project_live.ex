defmodule WebsiteWeb.ProjectLive do
  use Phoenix.LiveView

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket} = fetch_projects(socket)
    {:ok, socket}
  end

  def handle_event("refresh", _, socket) do
    case fetch_projects(socket) do
      {:ok, new_socket} ->
        {:noreply, assign(new_socket, :projects, new_socket.assigns[:projects])}
      {:error, reason} ->
        {:noreply, socket}
    end
  end
 
  def handle_event("view_readme", %{"repo" => repo}, socket) do
    markdown = fetch_repo_readme(repo)
    html = Jason.decode!(HTTPoison.post("https://api.github.com/markdown", %{
      text: markdown,
      mode: "gfm",
      context: repo
    }, [{"User-Agent", "website"}, {"Accept", "application/vnd.github.v3.text+html"}]).body) |> String.strip
    {:noreply, assign(socket, :selected_repo, %{name: repo, html: html})}
    end
    
    defp fetch_repo_readme(repo_full_name) do
    url = "https://api.github.com/repos/#{repo_full_name}/readme"
    headers = [{"User-Agent", "website"}]
    case HTTPoison.get(url, headers) do
      {:ok, %{status_code: 200, body: body}} ->
        content = Jason.decode!(body)
        Base.decode64!(content["content"]) |> String.strip
      _ ->
        ""
    end
  end



  def handle_event("close_readme", _, socket) do
    {:noreply, assign(socket, :selected_repo, nil)}
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
  
  
  
  defp render_card(project) do
    repo_full_name = project["full_name"]
    
    ~s"""
    <div class="project-card" phx-click="view_readme" phx-value-repo="#{repo_full_name}">
      <h3><%= project["name"] %></h3>
      <p><%= project["description"] || "" %></p
    </div>
    """
  end

    def render(assigns) do
    selected_repo = assigns[:selected_repo]

    projects = assigns[:projects] || []
    card_elements =
      for project <- projects, do: render_card(project)

    ~H"""
    
    """
  end
end
