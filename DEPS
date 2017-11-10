use_relative_paths = True

vars = {
  'ndk_revision': 'aabf5c8f4b1ce4269be4791b469e27b15d93a3f2',
}
deps = {
  'ndk': {
    # This is necessary for the buildspecs used on release branches.
    # See crbug.com/783607 for more context.
    'condition': 'checkout_android',
    'url': 'https://chromium.googlesource.com/android_ndk.git' + '@' + Var('ndk_revision'),
  }
}
