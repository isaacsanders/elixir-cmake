defmodule Mix.Tasks.Compile.Cmake do
  @moduledoc "Builds native source using CMake"
  use Mix.Task

  @default_cmakelists_path ".."
  @default_make_target "all"
  @default_working_dir "_cmake"

  @build_type_variable "CMAKE_BUILD_TYPE"

  @doc """
  Runs this task.
  """
  def run(_args) do
    :ok = File.mkdir_p(@default_working_dir)

    config =
      Mix.Project.config()
      |> Keyword.get(:cmake, [])

    build_flags =
      config
      |> Keyword.get(:build_flags, [])
      |> Enum.map(fn
        {name, type, value} ->
          "-D#{name}:#{type}=#{value}"

        {name, value} ->
          "-D#{name}=#{value}"
      end)

    cmd("cmake", build_flags ++ [build_type_flag(), @default_cmakelists_path])
    cmd("make", [@default_make_target])

    if Keyword.get(config, :install?, false) do
      cmd("make", ["install"])
    end

    :ok
  end

  @doc """
  Removes compiled artifacts.
  """
  def clean() do
    cmd("make", ["clean"])
    :ok
  end

  defp cmd(exec, args, dir \\ @default_working_dir) do
    case System.cmd(exec, args, cd: dir, stderr_to_stdout: true) do
      {result, 0} ->
        Mix.shell().info(result)
        :ok

      {result, status} ->
        Mix.raise("Failure running '#{exec}' (status: #{status}).\n#{result}")
    end
  end

  defp build_type_flag do
    build_type =
      case Mix.env() do
        :test ->
          "Debug"

        :dev ->
          "Debug"

        :prod ->
          "Release"
      end

    "-D#{@build_type_variable}=#{build_type}"
  end
end
