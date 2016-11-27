defmodule Benchee.Utility.FileIntegrationTest do
  use ExUnit.Case
  import Benchee.Utility.File

  @directory "testing/files"
  test ".each_input writes file contents just fine" do
    try do
      input_to_contents = %{
        "small input" => "abc"
        "big list"    => "ABC"
      }
      File.mkdir_p! @directory
      each_input(input_to_contents, "test.txt", fn(file, content) ->
        File.write(file, content)
      end)

      assert File.read "#{@directory}/test_small_input.txt" == "abc"
      assert File.read "#{@directory}/test_big_list.txt"    == "ABC"
    after
      File.rm_r! @directory
    end
  end
end
