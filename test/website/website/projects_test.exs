defmodule Website.Website.ProjectsTest do
  use Website.DataCase

  alias Website.Website.Projects

  describe "projects" do
    alias Website.Website.Projects.Project

    import Website.Website.ProjectsFixtures

    @invalid_attrs %{description: nil, name: nil, url: nil}

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Projects.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Projects.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      valid_attrs = %{description: "some description", name: "some name", url: "some url"}

      assert {:ok, %Project{} = project} = Projects.create_project(valid_attrs)
      assert project.description == "some description"
      assert project.name == "some name"
      assert project.url == "some url"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name", url: "some updated url"}

      assert {:ok, %Project{} = project} = Projects.update_project(project, update_attrs)
      assert project.description == "some updated description"
      assert project.name == "some updated name"
      assert project.url == "some updated url"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)
      assert project == Projects.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
  end
end
