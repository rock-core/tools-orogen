# frozen_string_literal: true

require "orogen/test"

module OroGen
    module Spec
        describe InputPort do
            before do
                @loader = Loaders::RTT.new("gnulinux")
                @project = Project.new(@loader)
                @task = @project.task_context "Task"
                @port = InputPort.new(@task, "test", "/double")
            end

            it "returns true in input?" do
                assert @port.input?
            end
        end
    end
end
