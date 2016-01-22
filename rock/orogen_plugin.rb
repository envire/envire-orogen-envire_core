
class OroGen::Gen::RTT_CPP::Typekit

    def wrapper_type_name_for type
        type = type.to_str
        type = Typelib::Type.normalize_typename(type)
        path = Typelib.split_typename(type)
        path.map! do |p|
            p.gsub(/[<>\[\], \/]/, '_')
        end
        "/" + path.join("/") + "_w"
    end

    def extend_includes_by_boost_serialization_includes options
        if options[:includes].respond_to?(:to_str)
            options[:includes] = [options[:includes]]
        end
        options[:includes].push("boost/archive/polymorphic_binary_iarchive.hpp")
        options[:includes].push("boost/archive/polymorphic_binary_oarchive.hpp")
        options[:includes].push("envire_core/typekit/BinaryBufferHelper.hpp")
        options
    end

    def opaque_autogen type, options = Hash.new
        options = Kernel.validate_options options,
            :include => [],
            :includes => [],
            :type => :boost_serialization,
            :embedded_type => nil

        # Check if type is already available
        begin
            t = find_type(type)
            if !t.nil?
                raise ArgumentError, "Type #{type} is already defined."
            end
        rescue Typelib::NotFound
        end

        orogen_install_path = File.expand_path(File.join('..'), File.dirname(__FILE__))

        if options[:type] == :boost_serialization

            # extend includes
            options = extend_includes_by_boost_serialization_includes options

            intermediate_type = wrapper_type_name_for type

            # create and load intermediate wrapper type
            begin
                t = find_type(intermediate_type)
            rescue Typelib::NotFound
                auto_gen_wrapper_code = Generation.render_template orogen_install_path, 'templates', 'auto_gen_types.hpp', binding
                path = Generation.save_automatic 'typekit', 'types', self.name, "wrappers", "#{Typelib.basename(intermediate_type)}.hpp", auto_gen_wrapper_code
                self.load(path, false)
            end

            # create c++ convertion code from template
            auto_gen_wrapper_code = Generation.render_template orogen_install_path, 'templates', 'opaque_convertions_boost_serialization.cpp', binding

            # register opaque type
            options.delete(:type)
            options.delete(:embedded_type)
            options[:needs_copy] = true
            opaque_type(type, intermediate_type, options) {auto_gen_wrapper_code}

        elsif options[:type] == :envire_serialization

            # check if embedded type is set
            if not options[:embedded_type].respond_to?(:to_str) or options[:embedded_type].empty?
                raise ArgumentError, "Cannot generate opaque for type #{type} without a valid type name for the embedded type of the envire::core::Item. (E.g. :embedded_type => '/pcl/PCLPointCloud2')"
            end

            begin
                # try to find embedded type
                embedded_type = find_type options[:embedded_type]
            rescue Typelib::NotFound
                RTT_CPP.info "Couldn't find typelib type for embedded type #{options[:embedded_type]}, trying to generate boost serialization based opaque type."
                # generate boost serialization based opaque type if not available
                opaque_autogen options[:embedded_type], :includes => options[:includes], :include => options[:include], :type => :boost_serialization
                embedded_type = find_type options[:embedded_type]
            end

            # extend includes
            options = extend_includes_by_boost_serialization_includes options

            intermediate_type = wrapper_type_name_for type

            #create and load intermediate wrapper type
            begin
                t = find_type(intermediate_type)
            rescue Typelib::NotFound
                auto_gen_wrapper_code = Generation.render_template orogen_install_path, 'templates', 'auto_gen_envire_types.hpp', binding
                path = Generation.save_automatic 'typekit', 'types', self.name, "wrappers", "#{Typelib.basename(intermediate_type)}.hpp", auto_gen_wrapper_code
                self.load(path, false)
            end

            # create c++ convertion code from template
            auto_gen_wrapper_code = Generation.render_template orogen_install_path, 'templates', 'opaque_convertions_envire_serialization.cpp', binding

            # register opaque type
            options.delete(:type)
            options.delete(:embedded_type)
            options[:needs_copy] = true
            opaque_type(type, intermediate_type, options) {auto_gen_wrapper_code}

        else
            raise ArgumentError, "Cannot generate opaque, #{options[:type]} is an unknown serialization type!"
        end

    end

end