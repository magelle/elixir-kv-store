defmodule KV.RouterTest do
    use ExUnit.Case, async: true
  
    @tag :distributed
    test "route requests across nodes" do
      assert KV.Router.route("hello", Kernel, :node, []) ==
             :"beam1@kata"
      assert KV.Router.route("world", Kernel, :node, []) ==
             :"beam2@kata"
    end
  
    test "raises on unknown entries" do
      assert_raise RuntimeError, ~r/could not find entry/, fn ->
        KV.Router.route(<<0>>, Kernel, :node, [])
      end
    end
  end
  