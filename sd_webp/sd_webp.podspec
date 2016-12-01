Pod::Spec.new do |spec|
  spec.name = "sd_webp"
  spec.version = "3.8.2"
  spec.summary = "animated webp"
  spec.homepage = "https://github.com/dulingkang/sd_webp"
  spec.license = { type: 'MIT', file: '../LICENSE' }
  spec.authors = { "Shawn Du" => 'dulingkang@163.com' }

  spec.platform = :ios, "7.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/dulingkang/sd_webp.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = 'SDWebImage/*.{h,m}'
  spec.description = 'This library provides a category for UIImageView with support for remote '      \
                  'images coming from the web. It provides an UIImageView category adding web '    \
                  'image and cache management to the Cocoa Touch framework, an asynchronous '      \
                  'image downloader, an asynchronous memory + disk image caching with automatic '  \
                  'cache expiration handling, a guarantee that the same URL won\'t be downloaded ' \
                  'several times, a guarantee that bogus URLs won\'t be retried again and again, ' \
                  'and performances!' \
'support animated webp'

  spec.requires_arc = true
  spec.framework = 'ImageIO'
  spec.xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) SD_WEBP=1',
      'USER_HEADER_SEARCH_PATHS' => '$(inherited) $(SRCROOT)/libwebp/src'
    }
  spec.watchos.xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) SD_WEBP=1 WEBP_USE_INTRINSICS=1',
      'USER_HEADER_SEARCH_PATHS' => '$(inherited) $(SRCROOT)/libwebp/src'
    }
  spec.dependency "libwebp"
end
