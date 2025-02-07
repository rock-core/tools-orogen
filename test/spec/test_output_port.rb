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

            it "initializes init_policy as nil" do
                assert_nil @port.init_policy
            end

            it "resets init_policy when port is created again" do
                @port.recommend_init
                assert @port.init_policy
                @port = OutputPort.new(@task, "test", "/double")
                assert_nil @port.init_policy
            end

            it "defaults keep_last_written_value to :initial" do
                assert_equal @port.keep_last_written_value, :initial
            end

            it "calls keep_last_written_value(true) with recommend_init" do
                @port.recommend_init
                assert @port.keep_last_written_value
            end

            it "calls keep_last_written_value(false) with " \
               "recommend_init(init: false)" do
                @port.recommend_init(init: false)
                refute @port.keep_last_written_value
            end

            it "raises ArgumentError if recommend_init is called " \
               "with an invalid value (other than true or false)" do
                begin
                    @port.recommend_init(init: nil)
                rescue ArgumentError => e
                    assert_equal e.message,
                                 "recommend_init can only be called with " \
                                 "true or false. Got nil"
                end
            end
        end
    end
end
