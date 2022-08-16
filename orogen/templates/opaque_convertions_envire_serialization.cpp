<%
# Generate boost serialization convertions
%>

<%
needed_typekits = Set.new
embedded_type_is_opaque = embedded_type.opaque?
if embedded_type_is_opaque
    needed_typekits |= imported_typekits_for(embedded_type).to_set
end
%>
<% needed_typekits.sort_by(&:name).each do |tk| %>
#include <<%= tk.name %>/typekit/OpaqueConvertions.hpp>
<% end %>

void orogen_typekits::toIntermediate(<%= Typelib::Type.normalize_cxxname(intermediate_type) %>& intermediate, <%= Typelib::Type.normalize_cxxname(type) %> const& real_type)
{
    intermediate.time = real_type.getTime();
    std::copy(std::begin(real_type.getID().data), std::end(real_type.getID().data), std::begin(intermediate.uuid));
    intermediate.frame = real_type.getFrame();
    <% if embedded_type_is_opaque %>
    toIntermediate(intermediate.data, real_type.getData());
    <% else %>
    intermediate.data = real_type.getData();
    <% end %>
}

void orogen_typekits::fromIntermediate(<%= Typelib::Type.normalize_cxxname(type) %>& real_type, <%= Typelib::Type.normalize_cxxname(intermediate_type) %> const& intermediate)
{
    real_type.setTime(intermediate.time);
    boost::uuids::uuid id;
    std::copy(std::begin(intermediate.uuid), std::end(intermediate.uuid), std::begin(id.data));
    real_type.setID(id);
    real_type.setFrame(intermediate.frame);
    <% if embedded_type_is_opaque %>
    fromIntermediate(real_type.getData(), intermediate.data);
    <% else %>
    real_type.setData(intermediate.data);
    <% end %>
}
