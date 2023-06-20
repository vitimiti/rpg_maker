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

  _colormap = XCreateColormap(_display, _root, _visual_info->visual, AllocNone);

  _set_window_attributes.colormap   = _colormap;
  _set_window_attributes.event_mask = ExposureMask | KeyPressMask;

  _window = XCreateWindow(
      _display, _root, static_cast<int>(attributes.x),
      static_cast<int>(attributes.y), attributes.width, attributes.height,
      attributes.border_width, _visual_info->depth, InputOutput,
      _visual_info->visual, CWColormap | CWEventMask, &_set_window_attributes);

  XStoreName(_display, _window, attributes.title.c_str());
  XSetIconName(_display, _window, attributes.icon_path.c_str());
  XMapWindow(_display, _window);
  glXMakeCurrent(_display, _window, _context);

  glEnable(GL_DEPTH_TEST);
}

window::~window() {
  glXMakeCurrent(_display, None, nullptr);
  glXDestroyContext(_display, _context);
  XDestroyWindow(_display, _window);
  XCloseDisplay(_display);
}

[[nodiscard]] auto window::get_attributes() const -> window_attributes {
  char* title = nullptr;
  XFetchName(_display, _window, &title);

  char* icon = nullptr;
  XGetIconName(_display, _window, &icon);

  XWindowAttributes attributes;
  XGetWindowAttributes(_display, _window, &attributes);

  return {.title        = title == nullptr ? "" : title,
          .icon_path    = icon == nullptr ? "" : icon,
          .x            = static_cast<std::uint32_t>(attributes.x),
          .y            = static_cast<std::uint32_t>(attributes.y),
          .width        = static_cast<std::uint32_t>(attributes.width),
          .height       = static_cast<std::uint32_t>(attributes.height),
          .border_width = static_cast<std::uint32_t>(attributes.border_width)};
}
} // namespace rpgmk::dl