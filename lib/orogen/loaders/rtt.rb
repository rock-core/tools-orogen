# frozen_string_literal: true

module OroGen
    module Loaders
        class RTT < PkgConfig
            DIR = File.join(File.expand_path(File.dirname(__FILE__)), "rtt")
            STANDARD_PROJECT_SPECS = { "RTT" => DIR }

            def self.loader
                loader = Files.new
                STANDARD_PROJECT_SPECS.each do |name, dir|
                    loader.register_orogen_file(File.join(dir, "#{name}.orogen"), name)
                end
                loader
            end

            def initialize(orocos_target = ENV["OROCOS_TARGET"], root_loader = self)
                super
            end

            def self.standard_projects
                unless @standard_projects
                    loader = self.loader
                    @standard_projects = STANDARD_PROJECT_SPECS.map do |name, dir|
                        loader.project_model_from_name(name)
                    end
                end
                @standard_projects
            end

            def self.setup_loader(loader)
                standard_projects.each do |proj|
                    loader.register_project_model(proj)
                end
            end

            def clear
                super
                RTT.setup_loader(self)
            end
        end
    end
end

