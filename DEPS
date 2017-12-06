use_relative_paths = True

vars = {
  'ndk_revision': '50f4963776c431db65f21e92e4a5e67a4b715920',
}
deps = {
  'ndk': {
    # This is necessary for the buildspecs used on release branches.
    # See crbug.com/783607 for more context.
    'condition': 'checkout_android',
    'url': 'https://chromium.googlesource.com/android_ndk.git' + '@' + Var('ndk_revision'),
  }
}
