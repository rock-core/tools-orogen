# Generated from orogen/lib/orogen/templates/tasks/CMakeLists.txt

include(<%= project.name %>TaskLib)
ADD_LIBRARY(${<%= project.name.upcase %>_TASKLIB_NAME} SHARED
    ${<%= project.name.upcase %>_TASKLIB_SOURCES})
<% if project.typekit %>
add_dependencies(${<%= project.name.upcase %>_TASKLIB_NAME}
    regen-typekit)
<% end %>

<% project.each_needed_global_cpp_initializer do |init| %>
<%= ERB.new(init.tasks_cmake).result(binding) %>
<% end %>

TARGET_LINK_LIBRARIES(${<%= project.name.upcase %>_TASKLIB_NAME}
    ${OrocosRTT_LIBRARIES}
    ${QT_LIBRARIES}
    ${<%= project.name.upcase %>_TASKLIB_DEPENDENT_LIBRARIES})
SET_TARGET_PROPERTIES(${<%= project.name.upcase %>_TASKLIB_NAME}
    PROPERTIES LINK_INTERFACE_LIBRARIES "${<%= project.name.upcase %>_TASKLIB_INTERFACE_LIBRARIES}")
SET_TARGET_PROPERTIES(${<%= project.name.upcase %>_TASKLIB_NAME}
    PROPERTIES INTERFACE_LINK_LIBRARIES "${<%= project.name.upcase %>_TASKLIB_INTERFACE_LIBRARIES}")

<% if project.cxx_standard %>
TARGET_COMPILE_FEATURES(${<%= project.name.upcase %>_TASKLIB_NAME} PUBLIC <%= project.cxx_standard.sub(/^(c|gnu)\+\+/, "cxx_std_") %>)
<% end %>

INSTALL(TARGETS ${<%= project.name.upcase %>_TASKLIB_NAME}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib/orocos)

INSTALL(FILES ${<%= project.name.upcase %>_TASKLIB_HEADERS}
    DESTINATION include/orocos/<%= project.name.downcase %>)

