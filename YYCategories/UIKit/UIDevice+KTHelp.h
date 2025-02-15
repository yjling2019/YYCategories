//
//  UIDevice+KTHelp.h
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/3.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIDevice`.
 */
@interface UIDevice (KTHelp)


#pragma mark - Device Information
///=============================================================================
/// @name Device Information
///=============================================================================

/// Device system version (e.g. 8.1)
+ (double)kt_systemVersion;

/// Whether the device is iPad/iPad mini.
@property (nonatomic, readonly) BOOL kt_isPad;

/// Whether the device is a simulator.
@property (nonatomic, readonly) BOOL kt_isSimulator;

/// Whether the device is jailbroken.
@property (nonatomic, readonly) BOOL kt_isJailbroken;

/// Wherher the device can make phone calls.
@property (nonatomic, readonly) BOOL kt_canMakePhoneCalls NS_EXTENSION_UNAVAILABLE_IOS("");

/// The device's machine model.  e.g. "iPhone6,1" "iPad4,6"
/// @see http://theiphonewiki.com/wiki/Models
@property (nullable, nonatomic, readonly) NSString *kt_machineModel;

/// The device's machine model name. e.g. "iPhone 5s" "iPad mini 2"
/// @see http://theiphonewiki.com/wiki/Models
@property (nullable, nonatomic, readonly) NSString *kt_machineModelName;

/// The System's startup time.
@property (nonatomic, readonly) NSDate *kt_systemUptime;


#pragma mark - Network Information
///=============================================================================
/// @name Network Information
///=============================================================================

/// WIFI IP address of this device (can be nil). e.g. @"192.168.1.111"
@property (nullable, nonatomic, readonly) NSString *kt_ipAddressWIFI;

/// Cell IP address of this device (can be nil). e.g. @"10.2.2.222"
@property (nullable, nonatomic, readonly) NSString *kt_ipAddressCell;


/**
 Network traffic type:
 
 WWAN: Wireless Wide Area Network.
       For example: 3G/4G.
 
 WIFI: Wi-Fi.
 
 AWDL: Apple Wireless Direct Link (peer-to-peer connection).
       For exmaple: AirDrop, AirPlay, GameKit.
 */
typedef NS_OPTIONS(NSUInteger, KTNetworkTrafficType) {
    KTNetworkTrafficTypeWWANSent     = 1 << 0,
    KTNetworkTrafficTypeWWANReceived = 1 << 1,
    KTNetworkTrafficTypeWIFISent     = 1 << 2,
    KTNetworkTrafficTypeWIFIReceived = 1 << 3,
    KTNetworkTrafficTypeAWDLSent     = 1 << 4,
    KTNetworkTrafficTypeAWDLReceived = 1 << 5,
    
    KTNetworkTrafficTypeWWAN = KTNetworkTrafficTypeWWANSent | KTNetworkTrafficTypeWWANReceived,
    KTNetworkTrafficTypeWIFI = KTNetworkTrafficTypeWIFISent | KTNetworkTrafficTypeWIFIReceived,
    KTNetworkTrafficTypeAWDL = KTNetworkTrafficTypeAWDLSent | KTNetworkTrafficTypeAWDLReceived,
    
    KTNetworkTrafficTypeALL = KTNetworkTrafficTypeWWAN |
                              KTNetworkTrafficTypeWIFI |
                              KTNetworkTrafficTypeAWDL,
};

/**
 Get device network traffic bytes.
 
 @discussion This is a counter since the device's last boot time.
 Usage:
 
     uint64_t bytes = [[UIDevice currentDevice] getNetworkTrafficBytes:KTNetworkTrafficTypeALL];
     NSTimeInterval time = CACurrentMediaTime();
     
     uint64_t bytesPerSecond = (bytes - _lastBytes) / (time - _lastTime);
     
     _lastBytes = bytes;
     _lastTime = time;
 
 
 @param types traffic types
 @return bytes counter.
 */
- (uint64_t)kt_getNetworkTrafficBytes:(KTNetworkTrafficType)types;

#pragma mark - Disk Space
///=============================================================================
/// @name Disk Space
///=============================================================================

/// Total disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kt_diskSpace;

/// Free disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kt_diskSpaceFree;

/// Used disk space in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kt_diskSpaceUsed;


#pragma mark - Memory Information
///=============================================================================
/// @name Memory Information
///=============================================================================

/// Total physical memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kt_memoryTotal;

/// Used (active + inactive + wired) memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kt_memoryUsed;

/// Free memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kt_memoryFree;

/// Acvite memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kt_memoryActive;

/// Inactive memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kt_memoryInactive;

/// Wired memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kt_memoryWired;

/// Purgable memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t kt_memoryPurgable;

#pragma mark - CPU Information
///=============================================================================
/// @name CPU Information
///=============================================================================

/// Avaliable CPU processor count.
@property (nonatomic, readonly) NSUInteger kt_cpuCount;

/// Current CPU usage, 1.0 means 100%. (-1 when error occurs)
@property (nonatomic, readonly) float kt_cpuUsage;

/// Current CPU usage per processor (array of NSNumber), 1.0 means 100%. (nil when error occurs)
@property (nullable, nonatomic, readonly) NSArray<NSNumber *> *kt_cpuUsagePerProcessor;

@end

NS_ASSUME_NONNULL_END

#ifndef kSystemVersion
#define kSystemVersion [UIDevice systemVersion]
#endif

#ifndef kiOS6Later
#define kiOS6Later (kSystemVersion >= 6)
#endif

#ifndef kiOS7Later
#define kiOS7Later (kSystemVersion >= 7)
#endif

#ifndef kiOS8Later
#define kiOS8Later (kSystemVersion >= 8)
#endif

#ifndef kiOS9Later
#define kiOS9Later (kSystemVersion >= 9)
#endif
