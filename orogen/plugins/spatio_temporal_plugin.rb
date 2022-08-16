
class OroGen::Gen::RTT_CPP::Typekit

    # Returns the SpatioTemporal typename for a given embedded type.
    #
    # @param [string] embedded typename
    def spatio_temporal_typename_for embedded_typename
        "/envire/core/SpatioTemporal<#{embedded_typename}>"
    end

    # Generates a SpatioTemporal<embedded_typename> type of the given embedded type.
    #
    # If the embedded type has an opaque type, it will create a SpatioTemporal type
    # using it's opaque and creates a conversion. Note that the embedded type needs
    # to be already exported.
    #
    # The following option is available:
    # +:include+ can be used to include additional headers.
    #
    # Examples:
    #    point_cloud_st = spatio_temporal '/pcl/PCLPointCloud2'
    #    export_types point_cloud_st
    #
    # @param [string] embedded typename
    def spatio_temporal embedded_typename, options = Hash.new
        # create a validated options-hash
        options = Kernel.validate_options options,
            # just the plain name of the header like "path/Header.hpp"
            :include => []

        orogen_install_path = File.expand_path(File.join('..'), File.dirname(__FILE__))

        # check if embedded type is set
        if not embedded_typename.respond_to?(:to_str) or embedded_typename.empty?
            raise ArgumentError, "Cannot generate #{spatio_temporal_typename_for "T"} type without a valid type name for the embedded type (E.g. '/pcl/PCLPointCloud2')"
        end

        begin
            # try to find the embedded type
            embedded_type = find_type embedded_typename
        rescue Typelib::NotFound
            raise ArgumentError, "Couldn't find typelib type for embedded type #{embedded_typename}, please export the type first!"
        end

        type_name = spatio_temporal_typename_for embedded_type.name

        # check if type is already available
        begin
            t = find_type(type_name)
            if !t.nil?
               return t
            end
        rescue Typelib::NotFound
        end

        auto_gen_wrapper_code = Generation.render_template orogen_install_path, 'templates', 'auto_gen_spatio_temporal_types.hpp', binding
        file_name = Typelib.basename(embedded_type.name).gsub(/[<>\[\], \/]/, '_')
        path = Generation.save_automatic 'typekit', 'types', self.name, "wrappers", "spatio_temporal", "#{file_name}.hpp", auto_gen_wrapper_code
        self.load(path)

        if embedded_type.opaque?
            if options[:include].respond_to?(:to_str)
                options[:include] = [options[:include]]
            end
            options[:include].concat(include_for_type(embedded_type))
            options[:include].push("envire_core/items/SpatioTemporal.hpp")
            embedded_type_intermediate = intermediate_type_for embedded_type

            intermediate_type = spatio_temporal_typename_for embedded_type_intermediate.name

            # create c++ convertion code from template
            opaque_convertion_code = Generation.render_template orogen_install_path, 'templates', 'opaque_convertions_spatio_temporal.cpp', binding
            opaque_type(type_name, intermediate_type, options) {opaque_convertion_code}
        end

        # perform pending loads
        if has_pending_loads?
            perform_pending_loads
        end

        # add aliases
        aliases = registry.aliases_of embedded_type
        aliases.each do |a|
            registry.alias spatio_temporal_typename_for(a), type_name
        end


        find_type(type_name)
    end

end

class OroGen::Spec::TaskContext

    # Resolves the spatio temporal type of a given embedded type
    # or creates one if it can't be found.
    #
    # Example:
    #   output_port "pointcloud", spatio_temporal("/pcl/PCLPointCloud2")
    #
    def spatio_temporal(name)
        base_type = project.resolve_type(name)
        full_name = "/envire/core/SpatioTemporal<#{base_type.name}>"
        begin
            project.resolve_type(full_name)
        rescue Typelib::NotFound
            if project.typekit(true).respond_to?(:spatio_temporal)
                project.typekit(true).spatio_temporal(name)
                project.resolve_type(full_name)
            else raise
            end
        end
    end

end
