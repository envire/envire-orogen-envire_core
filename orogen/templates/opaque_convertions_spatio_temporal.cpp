<%
# Generate spatio temporal convertions
%>

<%
needed_typekits = imported_typekits_for(embedded_type).to_set
%>
<% needed_typekits.sort_by(&:name).each do |tk| %>
#include <<%= tk.name %>/typekit/OpaqueConvertions.hpp>
<% end %>

void orogen_typekits::toIntermediate(<%= Typelib::Type.normalize_cxxname(intermediate_type) %>& intermediate, <%= Typelib::Type.normalize_cxxname(type_name) %> const& real_type)
{
    intermediate.time = real_type.time;
    intermediate.uuid = real_type.uuid;
    intermediate.frame_id = real_type.frame_id;
    toIntermediate(intermediate.data, real_type.data);
}

void orogen_typekits::fromIntermediate(<%= Typelib::Type.normalize_cxxname(type_name) %>& real_type, <%= Typelib::Type.normalize_cxxname(intermediate_type) %> const& intermediate)
{
    real_type.time = intermediate.time;
    real_type.uuid = intermediate.uuid;
    real_type.frame_id = intermediate.frame_id;
    fromIntermediate(real_type.data, intermediate.data);
}
