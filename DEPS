use_relative_paths = True

vars = {
  'ndk_revision': '5fda77d1e724be951783a8449c6167c7db90b197',
}
deps = {
  'ndk': {
    # This is necessary for the buildspecs used on release branches.
    # See crbug.com/783607 for more context.
    'condition': 'checkout_android',
    'url': 'https://chromium.googlesource.com/android_ndk.git' + '@' + Var('ndk_revision'),
  }
}
