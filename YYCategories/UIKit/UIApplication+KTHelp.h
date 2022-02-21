//
//  UIApplication+KTHelp.h
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/4.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIApplication`.
 */
@interface UIApplication (KTHelp)

/// "Documents" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *kt_documentsURL;
@property (nonatomic, readonly) NSString *kt_documentsPath;

/// "Caches" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *kt_cachesURL;
@property (nonatomic, readonly) NSString *kt_cachesPath;

/// "Library" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *kt_libraryURL;
@property (nonatomic, readonly) NSString *kt_libraryPath;

/// Application's Bundle Name (show in SpringBoard).
@property (nullable, nonatomic, readonly) NSString *kt_appBundleName;

/// Application's Bundle ID.  e.g. "com.ibireme.MyApp"
@property (nullable, nonatomic, readonly) NSString *kt_appBundleID;

/// Application's Version.  e.g. "1.2.0"
@property (nullable, nonatomic, readonly) NSString *kt_appVersion;

/// Application's Build number. e.g. "123"
@property (nullable, nonatomic, readonly) NSString *kt_appBuildVersion;

/// Whether this app is priated (not install from appstore).
@property (nonatomic, readonly) BOOL kt_isPirated;

/// Whether this app is being debugged (debugger attached).
@property (nonatomic, readonly) BOOL kt_isBeingDebugged;

/// Current thread real memory used in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kt_memoryUsage;

/// Current thread CPU usage, 1.0 means 100%. (-1 when error occurs)
@property (nonatomic, readonly) float kt_cpuUsage;


/**
 Increments the number of active network requests.
 If this number was zero before incrementing, this will start animating the 
 status bar network activity indicator.
 
 This method is thread safe.
 */
- (void)kt_incrementNetworkActivityCount;

/**
 Decrements the number of active network requests. 
 If this number becomes zero after decrementing, this will stop animating the 
 status bar network activity indicator.
 
 This method is thread safe.
 */
- (void)kt_decrementNetworkActivityCount;


/// Returns YES in App Extension.
+ (BOOL)kt_isAppExtension;

/// Same as sharedApplication, but returns nil in App Extension.
+ (nullable UIApplication *)kt_sharedExtensionApplication;

@end

NS_ASSUME_NONNULL_END
