# Generated from orogen/lib/orogen/templates/typekit/corba/CMakeLists.txt

<% typekit_deps = typekit.plugin('corba').dependencies %>

find_package(OrocosCORBA REQUIRED COMPONENTS Typekit)
INCLUDE_DIRECTORIES(${OrocosCORBA_INCLUDE_DIRS})
ADD_DEFINITIONS(${OrocosCORBA_DEFINES})

include_directories(${OrocosCORBA_INCLUDE_DIRS})
add_definitions(${OrocosCORBA_CFLAGS_OTHER})
link_directories(${OrocosCORBA_LIBRARY_DIRS})

<%= Generation.cmake_pkgconfig_require(typekit_deps, 'corba') %>

# Set up generation of IDL files for CORBA support
IF (NOT OrocosCORBA_Typekit_FOUND)
    MESSAGE(FATAL_ERROR "could not find development files for Orocos/CORBA")
ENDIF(NOT OrocosCORBA_Typekit_FOUND)

set(CORBA_FILES ${CMAKE_CURRENT_BINARY_DIR}/<%= typekit.name %>TypesC.cpp)
if(CORBA_IMPLEMENTATION STREQUAL "OMNIORB")
    list(APPEND CORBA_FILES ${CMAKE_CURRENT_BINARY_DIR}/<%= typekit.name %>TypesDynSK.cpp)
endif(CORBA_IMPLEMENTATION STREQUAL "OMNIORB")

add_custom_command(OUTPUT ${CORBA_FILES}
    COMMAND ${OrocosCORBA_IDL} -Wbkeep_inc_path
        <%= corba_plugin.corba_idl_requires.to_a.sort
                        .map { |name| typekit.project.orogen_typekit_package(name).prefix }
                        .map { |prefix| "-I" + File.join(prefix, "include", "orocos") }.join(" ") %>
        ${CMAKE_CURRENT_SOURCE_DIR}/<%= typekit.name %>Types.idl
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/<%= typekit.name %>Types.idl)

add_definitions(${OrocosCORBA_Typekit_DEFINES})
include_directories(${OrocosCORBA_Typekit_INCLUDE_DIRS})

# Generate the CORBA transport
set(libname_corba <%= typekit.name %>-transport-corba-${OROCOS_TARGET})
add_library(${libname_corba} SHARED
    <%= impl.join("\n    ") %>
    ${CORBA_FILES})
if (CXX_SUPPORTS_WUNUSED_VARIABLE)
    set_source_files_properties(${CORBA_FILES} TARGET_COMPILE_OPTIONS "-Wno-unused-variable")
endif()

target_link_libraries(${libname_corba}
    <%= typekit.name %>-typekit-${OROCOS_TARGET}
    ${OrocosCORBA_LIBRARIES})
if(WITH_RPATH AND APPLE)
  set_target_properties( ${libname_corba} PROPERTIES
    INSTALL_NAME_DIR "@rpath")
    SET(CMAKE_BUILD_WITH_INSTALL_RPATH ON)
endif()

<%= Generation.cmake_pkgconfig_link('corba', '${libname_corba}', typekit_deps) %>
set_target_properties(${libname_corba} PROPERTIES LINK_INTERFACE_LIBRARIES ${OrocosCORBA_LIBRARIES})
set_target_properties(${libname_corba} PROPERTIES INTERFACE_LINK_LIBRARIES ${OrocosCORBA_LIBRARIES})

<% if typekit.cxx_standard %>
target_compile_features(${libname_corba} PUBLIC <%= typekit.cxx_standard.sub(/^(c|gnu)\+\+/, "cxx_std_") %>)
<% end %>

SET(PKG_CONFIG_FILE_CORBA ${CMAKE_CURRENT_BINARY_DIR}/<%= typekit.name %>-transport-corba-${OROCOS_TARGET}.pc)
CONFIGURE_FILE(<%= typekit.name %>-transport-corba.pc.in ${PKG_CONFIG_FILE_CORBA} @ONLY)

install(TARGETS ${libname_corba} LIBRARY DESTINATION lib/orocos${OROCOS_PKG_DIR}/types)
install(FILES ${PKG_CONFIG_FILE_CORBA} DESTINATION lib/pkgconfig)
install(FILES
    <%= headers.join("\n   ") %>
    <%= typekit.name %>Types.idl
    ${CMAKE_CURRENT_BINARY_DIR}/<%= typekit.name %>TypesC.h
    DESTINATION include/orocos/<%= typekit.name %>/transports/corba)

