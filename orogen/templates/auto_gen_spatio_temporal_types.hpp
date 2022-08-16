/* Generated from orogen/lib/orogen/templates/typekit/marshalling_types.hpp */

<% embedded_typename_mangled = embedded_typename.gsub(/[<>\[\], \/]/, '_').gsub(/\*/, 'P')
   if embedded_type.opaque?
        embedded_type_intermediate = intermediate_type_for embedded_type
        embedded_type_cxx = Typelib::Type.normalize_cxxname(embedded_type_intermediate.name)
        embedded_type_includes = include_for_type(embedded_type_intermediate)
   else
        embedded_type_cxx = Typelib::Type.normalize_cxxname(embedded_type.name)
        embedded_type_includes = include_for_type(embedded_type)
   end
%>

#ifndef _OROGEN_SPATIO_TEMPORAL_WRAPPER_TYPES_<%= embedded_typename_mangled.upcase %>_HPP
#define _OROGEN_SPATIO_TEMPORAL_WRAPPER_TYPES_<%= embedded_typename_mangled.upcase %>_HPP

#include <envire_core/items/SpatioTemporal.hpp>

<%
embedded_type_includes.each do |include|
%>
#include <<%= include %>>
<% end %>


namespace base { namespace wrappers {

    struct __gccxml_workaround_<%= embedded_typename_mangled.downcase %>_instanciator {
        envire::core::SpatioTemporal< <%= embedded_type_cxx %> > <%= embedded_typename_mangled.downcase %>;
    };

    typedef envire::core::SpatioTemporal< <%= embedded_type_cxx %> > SpatioTemporal<%= embedded_typename_mangled %>;

}}

#endif
