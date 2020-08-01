#pragma once

#include "type_safe/strong_typedef.hpp"

#include <intsafe.h>
#include <variant>
#include <utility>
#include <cstdint>

// Keycode vs character

namespace ts = type_safe;

using Keycode = int;

struct Character {
	UINT v;
};


using Input = std::variant<Keycode, Character>;
