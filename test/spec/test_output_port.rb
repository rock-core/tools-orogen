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

            it "defaults init_policy as not defined (false)" do
                refute @port.init_policy?
            end

            it "resets init_policy when port is created again" do
                @port.init_policy(true)
                assert @port.init_policy?
                @port = OutputPort.new(@task, "test", "/double")
                refute @port.init_policy?
            end

            it "defaults keep_last_written_value to :initial" do
                assert_equal @port.keep_last_written_value, :initial
            end

            it "calls keep_last_written_value(true) with init_policy(true)" do
                @port.init_policy(true)
                assert @port.keep_last_written_value
            end

            it "calls keep_last_written_value(false) with init_policy(false)" do
                @port.init_policy(false)
                refute @port.keep_last_written_value
            end

            it "sets init_policy to true and expects to get current value when " \
               "calling init_policy" do
                @port.init_policy(true)
                assert @port.init_policy?
            end

            it "sets init_policy to false and expects to get current value when " \
               "calling init_policy" do
                @port.init_policy(false)
                refute @port.init_policy?
            end

            it "raises ArgumentError if init_policy is called " \
               "with an invalid value (other than true or false)" do
                begin
                    @port.init_policy(nil)
                rescue ArgumentError => e
                    assert_equal e.message,
                                 "init_policy can only be called with " \
                                 "true or false. Got nil"
                end
            end
        end
    end
end
