/* Generated from orogen/lib/orogen/templates/typekit/marshalling_types.hpp */

<% target_namespace = Typelib.namespace(intermediate_type)
   target_basename  = Typelib.basename(intermediate_type)
   target_basename.gsub!('/', '::')
   if embedded_type.opaque?
        embedded_type_intermediate = intermediate_type_for embedded_type
        embedded_type_cxx = Typelib::Type.normalize_cxxname(embedded_type_intermediate.name)
        embedded_type_includes = include_for_type(embedded_type_intermediate)
   else
        embedded_type_cxx = Typelib::Type.normalize_cxxname(embedded_type.name)
        embedded_type_includes = include_for_type(embedded_type)
   end
%>

#ifndef _OROGEN_ENVIRE_WRAPPER_TYPES_<%= target_basename.upcase %>_HPP
#define _OROGEN_ENVIRE_WRAPPER_TYPES_<%= target_basename.upcase %>_HPP

#include <vector>
#include <string>
#include <stdint.h>
#include <base/Time.hpp>

<%
embedded_type_includes.each do |include|
%>
#include <<%= include %>>
<% end %>

<%= Generation.adapt_namespace('/', target_namespace) %>

struct <%= target_basename %>
{
    base::Time time;
    uint8_t uuid[16];
    std::string frame;
    <%= embedded_type_cxx %> data;
};

<%= Generation.adapt_namespace(target_namespace, '/') %>

#endif
