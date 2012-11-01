set(PROJECT_NAME <%= typekit.name %>_msgs)
set(<%= typekit.name %>_msgs_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
<% typekit_deps = typekit.plugin('ros').dependencies(typekit); %>

find_package(catkin REQUIRED)
find_package(genmsg REQUIRED)

<%= Generation.cmake_pkgconfig_require(typekit_deps, 'ros') %>

add_message_files(DIRECTORY msg
    FILES
    <%= all_messages.join(".msg\n    ") %>.msg)

<%
msg_deps = typekit.used_typekits.map do |tk|
    next if tk.virtual?
    tk.name
end.compact
%>

<% msg_deps.each do |dep_name| %>
find_package(<%= dep_name %>_msgs)
<% end %>

<% if msg_deps.empty? %>
generate_messages()
<% else %>
generate_messages(DEPENDENCIES <%= msg_deps.join(" ") %>)
<% end %>
include_directories(${CMAKE_BINARY_DIR}/gen/cpp)

set(libname_ros <%= typekit.name %>-transport-ros-${OROCOS_TARGET})
add_library(${libname_ros} SHARED
    <%= impl.join("\n    ") %>)
target_link_libraries(${libname_ros}
    <%= typekit.name %>-typekit-${OROCOS_TARGET}
    ${OrocosROS_LIBRARIES})

SET(PKG_CONFIG_FILE_ROS ${CMAKE_CURRENT_BINARY_DIR}/<%= typekit.name
    %>-transport-ros-${OROCOS_TARGET}.pc)
CONFIGURE_FILE(<%= typekit.name %>-transport-ros.pc.in ${PKG_CONFIG_FILE_ROS} @ONLY)
install(TARGETS ${libname_ros} LIBRARY DESTINATION lib/orocos/types)
install(FILES ${PKG_CONFIG_FILE_ROS} DESTINATION lib/pkgconfig)
install(FILES
    <%= headers.join("\n   ") %>
    Convertions.hpp
    DESTINATION include/orocos/<%= typekit.name %>/transports/ros)