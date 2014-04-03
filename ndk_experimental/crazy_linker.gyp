# Copyright (c) 2013 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# This is a GYP include file that contains directives to build the
# crazy_linker sources as _part_ of another target.

{
  'targets': [
    {
      # Dummy crazy_linker target to keep gyp happy.
      'target_name': 'crazy_linker',
      'type': 'none'
    },
  ],
}
