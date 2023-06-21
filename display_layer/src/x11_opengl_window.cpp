//==============================================================================
// The MIT License (MIT)
//
// Copyright (c) 2023 Victor Matia <vmatir@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//==============================================================================

#include "rpgmk/dl/window.hpp"

// TODO: Use custom exception and error system.

namespace rpgmk::dl {
window::window(rpgmk::dl::window_attributes const& attributes) {
  if (_display == nullptr) {
    throw std::runtime_error("Unable to connect to the X11 display");
  }

  _root        = DefaultRootWindow(_display);
  _visual_info = glXChooseVisual(_display, 0, _attributes.data());
  if (_visual_info == nullptr) {
    throw std::runtime_error(
        "Unable to create visual information for GLX from the X11 display");
  }

  if (_colormap =
          XCreateColormap(_display, _root, _visual_info->visual, AllocNone);
      _colormap == BadAlloc || _colormap == BadColor || _colormap == BadMatch ||
      _colormap == BadValue || _colormap == BadWindow) {
    throw std::runtime_error("Unable to create the X11 color map");
  }

  _set_window_attributes.colormap   = _colormap;
  _set_window_attributes.event_mask = ExposureMask | KeyPressMask;

  if (_window =
          XCreateWindow(_display, _root, static_cast<int>(attributes.x),
                        static_cast<int>(attributes.y), attributes.width,
                        attributes.height, attributes.border_width,
                        _visual_info->depth, InputOutput, _visual_info->visual,
                        CWColormap | CWEventMask, &_set_window_attributes);
      _window == BadAlloc || _window == BadColor || _window == BadCursor ||
      _window == BadMatch || _window == BadPixmap || _window == BadValue ||
      _window == BadWindow) {
    throw std::runtime_error("Unable to create the X11 window");
  }

  if (auto error = XStoreName(_display, _window, attributes.title.c_str());
      error == BadAlloc || error == BadWindow) {
    throw std::runtime_error("Unable to set the X11 window title");
  }

  if (auto error =
          XSetIconName(_display, _window, attributes.icon_path.c_str());
      error == BadAlloc || error == BadWindow) {
    throw std::runtime_error("Unable to set the X11 icon name");
  }
}

window::~window() noexcept {
  glXMakeCurrent(_display, None, nullptr);
  glXDestroyContext(_display, _context);
  XDestroyWindow(_display, _window);
  XCloseDisplay(_display);
}

auto window::show() -> void {
  if (auto error = XMapWindow(_display, _window); error != Success) {
    throw std::runtime_error("Unable to show the X11 window");
  }

  if (auto error = glXMakeCurrent(_display, _window, _context);
      error != Success) {
    throw std::runtime_error("Unable to make the current X11 GLX context");
  }

  glEnable(GL_DEPTH_TEST);
}

[[nodiscard]] auto window::get_attributes() const -> window_attributes {
  char* title = nullptr;
  if (auto error = XFetchName(_display, _window, &title);
      error == BadAlloc || error == BadWindow) {
    throw std::runtime_error("Unable to get the X11 window name");
  }

  char* icon = nullptr;
  if (auto error = XGetIconName(_display, _window, &icon);
      error == BadAlloc || error == BadWindow) {
    throw std::runtime_error("Unable to get the X11 icon name");
  }

  XWindowAttributes attributes;
  if (auto error = XGetWindowAttributes(_display, _window, &attributes);
      error == BadDrawable || error == BadWindow) {
    throw std::runtime_error("Unable to get the X11 window attributes");
  }

  return {.title        = title == nullptr ? "" : title,
          .icon_path    = icon == nullptr ? "" : icon,
          .x            = static_cast<std::uint32_t>(attributes.x),
          .y            = static_cast<std::uint32_t>(attributes.y),
          .width        = static_cast<std::uint32_t>(attributes.width),
          .height       = static_cast<std::uint32_t>(attributes.height),
          .border_width = static_cast<std::uint32_t>(attributes.border_width)};
}
} // namespace rpgmk::dl