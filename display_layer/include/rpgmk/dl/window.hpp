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

#ifndef RPGMK_DL_WINDOW_HPP
#define RPGMK_DL_WINDOW_HPP

#include "rpgmk/dl/window_attributes.hpp"

#if RPGMK_X11
#  include <X11/X.h>
#  include <X11/Xlib.h>
#endif // Window API

#if RPGMK_OPENGL
#  include <array>

#  include <GL/gl.h>
#  include <GL/glu.h>
#  include <GL/glx.h>
#endif // Graphics API

namespace rpgmk::dl {
class window {
public:
  window() = delete;
  explicit window(window_attributes const& attributes);
  window(window const&)                    = delete;
  window(window&&)                         = delete;
  auto operator=(window const&) -> window& = delete;
  auto operator=(window&&) -> window&      = delete;
  ~window();

  [[nodiscard]] auto get_attributes() const -> window_attributes;

private:
#if RPGMK_X11
  Display*             _display = XOpenDisplay(nullptr);
  Window               _root;
  Window               _window;
  Colormap             _colormap;
  XSetWindowAttributes _set_window_attributes{};
#endif // Window API

#if RPGMK_OPENGL
  static GLint const _num_attributes       = 5;
  static GLint const _attribute_depth_size = 24;

  std::array<GLint, _num_attributes> _attributes = {
      GLX_RGBA, GLX_DEPTH_SIZE, _attribute_depth_size, GLX_DOUBLEBUFFER, None};

  XVisualInfo* _visual_info;
  GLXContext   _context{};
#endif // Graphics API
};
} // namespace rpgmk::dl

#endif // RPGMK_DL_WINDOW_HPP