PROJECT(envire_core)
cmake_minimum_required(VERSION 2.6)
SET (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")

SET (CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/.orogen/config")
INCLUDE(envire_coreBase)

install(FILES ${PROJECT_SOURCE_DIR}/rock/orogen_plugin.rb
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/orogen/plugins
        RENAME opaque_generation_plugin.rb)

file(GLOB TYPEKIT_TEMPLATES
    ${PROJECT_SOURCE_DIR}/rock/typekit/templates/*.hpp
    ${PROJECT_SOURCE_DIR}/rock/typekit/templates/*.cpp)
install(FILES ${TYPEKIT_TEMPLATES}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/orogen/templates/)

install(FILES ${PROJECT_SOURCE_DIR}/rock/typekit/BinaryBufferHelper.hpp
    DESTINATION include/orocos/envire_core/typekit)

# FIND_PACKAGE(KDL)
# FIND_PACKAGE(OCL)

