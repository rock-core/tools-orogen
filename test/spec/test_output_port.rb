# frozen_string_literal: true

require "orogen/test"

module OroGen
    module Spec
        describe OutputPort do
            before do
                @loader = Loaders::RTT.new("gnulinux")
                @project = Project.new(@loader)
                @task = @project.task_context "Task"
                @port = OutputPort.new(@task, "test", "/double")
            end

            it "returns false in input?" do
                refute @port.input?
            end

            it "defaults recommend_init to true" do
                assert @port.recommend_init
            end

            it "allows recommend_init to be explicitly set to false" do
                @port.recommend_init = false
                refute @port.recommend_init
            end

            it "sets recommend_init when recommends_init is called" do
                @port.recommend_init
                assert @port.recommend_init
            end
        end
    end
end
