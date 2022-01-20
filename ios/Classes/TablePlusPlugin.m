#import "TablePlusPlugin.h"
#if __has_include(<table_plus/table_plus-Swift.h>)
#import <table_plus/table_plus-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "table_plus-Swift.h"
#endif

@implementation TablePlusPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTablePlusPlugin registerWithRegistrar:registrar];
}
@end
