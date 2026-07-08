// bits/stdc++.h — shim for macOS / libc++ (Apple Clang doesn't ship GCC's
// libstdc++ convenience header). Pulls in the standard library so that
// competitive-programming files using `#include <bits/stdc++.h>` resolve
// under clangd and when compiled with clang++.

#ifndef CF_BITS_STDCXX_H
#define CF_BITS_STDCXX_H

// C++ library headers
#include <algorithm>
#include <array>
#include <atomic>
#include <bitset>
#include <chrono>
#include <cmath>
#include <complex>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <deque>
#include <exception>
#include <fstream>
#include <functional>
#include <iomanip>
#include <ios>
#include <iosfwd>
#include <iostream>
#include <istream>
#include <iterator>
#include <limits>
#include <list>
#include <map>
#include <memory>
#include <new>
#include <numeric>
#include <ostream>
#include <queue>
#include <random>
#include <set>
#include <sstream>
#include <stack>
#include <stdexcept>
#include <streambuf>
#include <string>
#include <tuple>
#include <typeinfo>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <valarray>
#include <vector>

// C++17 additions
#if __cplusplus >= 201703L
#include <any>
#include <optional>
#include <string_view>
#include <variant>
#endif

// C++20 additions
#if __cplusplus >= 202002L
#include <bit>
#include <compare>
#include <concepts>
#include <numbers>
#include <ranges>
#include <span>
#endif

#endif // CF_BITS_STDCXX_H
