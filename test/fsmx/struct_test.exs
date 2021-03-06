defmodule Fsmx.StructTest do
  use ExUnit.Case

  alias Fsmx.TestStructs.{Simple, WithCallbacks, WithSeparateFsm}

  describe "transition/2" do
    test "can do simple transitions" do
      one = %Simple{state: "1"}

      {:ok, two} = Fsmx.transition(one, "2")

      assert %Simple{state: "2"} = two

      {:ok, three} = Fsmx.transition(two, "3")

      assert %Simple{state: "3"} = three
    end

    test "fails to perform invalid transitions" do
      one = %Simple{state: "1"}

      assert {:error, msg} = Fsmx.transition(one, "3")

      assert msg == "invalid transition from 1 to 3"
    end
  end

  describe "transition/2 with before_callbacks" do
    test "calls before_transition/2 on struct" do
      one = %WithCallbacks.ValidBefore{state: "1", before: false}

      {:ok, two} = Fsmx.transition(one, "2")

      assert %WithCallbacks.ValidBefore{state: "2", before: "1"} = two
    end

    test "fails to transition if before_transition/3 returns an error" do
      one = %WithCallbacks.InvalidBefore{state: "1", before: false}

      {:error, :before_failed} = Fsmx.transition(one, "2")
    end
  end

  describe "transition/2 with separate fsm module" do
    test "works just the same" do
      one = %WithSeparateFsm{state: "1"}

      {:ok, two} = Fsmx.transition(one, "2")

      assert %WithSeparateFsm{state: "2", before: "1"} = two
    end
  end
end
