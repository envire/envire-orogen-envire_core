#ifndef _OROGEN_ENVIRE_CORE_TYPES_HPP
#define _OROGEN_ENVIRE_CORE_TYPES_HPP

#include <boost/uuid/uuid.hpp>

namespace wrappers
{
    struct __gccxml_workaround_boost_uuid_wrappers_instanciator {
        boost::uuids::uuid uuid;
    };

    typedef boost::uuids::uuid uuid;
}

#endif