//
//  WLFeatureValidateLog.m
//  LocalDemo
//
//  Created by QingCan on 2017/11/22.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "WLFeatureValidateLog.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioSession.h>
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVFoundation.h>

#import <objc/runtime.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/mount.h>
#include <mach/machine.h>
#include <sys/types.h>

#import <mach/mach.h>
#import <assert.h>
#import <UIKit/UIKit.h>
@interface WLFeatureValidateLog ()

@property (nonatomic,strong)CMAltimeter *altimeters;
@property (nonatomic,strong)NSString *volumeSize;
@property (nonatomic,strong,readwrite)id result;

@end

@implementation WLFeatureValidateLog

- (instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
        //让 UIApplication 开始响应远程的控制，必须添加，不然没效果
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    return self;
}

- (id)makeResult{
//    return [self isHeadsetPluggedIn];
    return [self gainVolume];
    return [self queryMagnetic];
    return [self queryOrientation];
    return [self queryBatteryState];
    return [self queryBattery];
    return [self getUserActivity];
    return [self isJingyin];
    
    return [self getCarrierInfo];
    return [self getDaqiya];
    return [self getFreeDiskSpace];
    return [self getTotalDiskSpace];
    
    
    NSString *str = [NSString stringWithFormat:@"total:%@ \r\n useage:%@ \r\n  free:%@",[self getTotalMemory],[self getUsageMemory],[self getFreeMemory]];
    return str;
    return [self getUsageMemory];
    return [self getFreeMemory];
    return [self getTotalMemory];
    
    return [self getCPUCount];
    return [self testForCPUUsage];
    return [self testForCPUType];
}

//- (instancetype)initWithParam:(id)params{
//
//}

#pragma mark 获取磁场强度值
- (NSString *)queryMagnetic{
    // 1. 创建CMMotionManager对象
    CMMotionManager *motionMgr = [CMMotionManager new];
    
    // 2. 判断磁力计是否可用
    if (![motionMgr isMagnetometerAvailable]) {
        return nil;
    }
    // 3. 设置采样间隔 单位是秒 --> 只有push方式需要采样间隔
    motionMgr.magnetometerUpdateInterval = 1;
    
    // 4. 开始采样
    [motionMgr startMagnetometerUpdatesToQueue:[NSOperationQueue new] withHandler:^(CMMagnetometerData * _Nullable gyroData, NSError * _Nullable error) {
        
        // 5 获取data中的数据  单位：特斯拉,
        CMMagneticField magneticField = motionMgr.magnetometerData.magneticField;
        
        NSLog(@"x : %f, y : %f, z : %f", magneticField.x, magneticField.y, magneticField.z);
        [motionMgr stopMagnetometerUpdates];
    }];
    
    return nil;
    
    // 3. 开始采样
////    [motionMgr startMagnetometerUpdates];
////    CMMagneticField magneticField = motionMgr.magnetometerData.magneticField;
//    return [NSString stringWithFormat:@"x=%f,y=%f,z=%f",magneticField.x,magneticField.y,magneticField.z];
}

#pragma mark 获取光线亮度值
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
//
//    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
//    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary *)metadataDict];
//    CFRelease(metadataDict);
//    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
//    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
//
//    NSLog(@"brightnessValue %f", brightnessValue);
//}

//brightnessValue 值越大越亮。


#pragma mark 横竖屏信息
- (NSString *)queryOrientation{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    NSString *orientationString = nil;
    switch (orientation) {
        case UIDeviceOrientationUnknown:
            orientationString = @"未知方向";
            break;
        case UIDeviceOrientationFaceUp:
            orientationString = @"竖屏方向";
            break;
        case UIDeviceOrientationFaceDown:
            orientationString = @"屏幕朝下";
            break;
        case UIDeviceOrientationPortrait:
            orientationString = @"竖屏向下";
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientationString = @"横屏向左";
            break;
        case UIDeviceOrientationLandscapeRight:
            orientationString = @"横屏向右";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientationString = @"竖屏向上";
            break;
        default:
            break;
    }
    return orientationString;
}

#pragma mark 电量
- (NSString *)queryBattery{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    float battery = [[UIDevice currentDevice] batteryLevel];
    [UIDevice currentDevice].batteryMonitoringEnabled = NO;
    return [NSString stringWithFormat:@"%.f",battery*100];
}

- (NSString *)queryBatteryState{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    NSString *status = nil;
    UIDeviceBatteryState state = [[UIDevice currentDevice] batteryState];
    switch (state) {
        case UIDeviceBatteryStateFull:
            status = @"充满电量";
            break;
        case UIDeviceBatteryStateCharging:
            status = @"正在充电";
            break;
        case UIDeviceBatteryStateUnplugged:
            status = @"未充电";
            break;
        case UIDeviceBatteryStateUnknown:
            status = @"未知状态";
            break;
        default:
            break;
    }
    [UIDevice currentDevice].batteryMonitoringEnabled = NO;
    return status;
}

#pragma mark 测试CPU使用率
- (NSString *)testForCPUUsage{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return @"-1";
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return @"-1";
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return @"-1";
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    return [NSString stringWithFormat:@"%.2f",tot_cpu];
    
}
#pragma mark CPU型号
- (NSString *)testForCPUType{
    size_t size;
    NSMutableString *cpu = [[NSMutableString alloc] init];
    
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    
    // values for cputype and cpusubtype defined in mach/machine.h
    if (type == CPU_TYPE_X86)
    {
        [cpu appendString:@"x86 "];
        // check for subtype ...
        
    } else if (type == CPU_TYPE_ARM)
    {
        [cpu appendString:@"ARM"];
        switch(subtype)
        {
            case CPU_SUBTYPE_ARM_V7:
                [cpu appendString:@"V7"];
                break;
            case CPU_SUBTYPE_ARM_V7S:
                [cpu appendString:@"V7s"];
                break;
                // ...
        }
    }
    
    NSLog(@"cpu 型号 :%@",cpu);
    return cpu;
}

#pragma mark 获取Cpu核心数
- (NSString *)getCPUCount {
    return [NSString stringWithFormat:@"%ld",[NSProcessInfo processInfo].activeProcessorCount];

}

#pragma mark 获取总内存大小
- (NSString *)getTotalMemory{
    int64_t totalMemory = [[NSProcessInfo processInfo] physicalMemory];
    if (totalMemory < -1) totalMemory = -1;
    return [NSString stringWithFormat:@"%lld m",totalMemory/(1024*1024)];
//    return totalMemory;
}

#pragma mark 可用内存空间大小
- (NSString *)getFreeMemory{
//    mach_port_t host_port = mach_host_self();
//    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
//    vm_size_t page_size;
//    vm_statistics_data_t vm_stat;
//    kern_return_t kern;
//
//    long long freeMem = 0;
//
//    kern = host_page_size(host_port, &page_size);
//    if (kern != KERN_SUCCESS) freeMem = -1;
//    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
//    if (kern != KERN_SUCCESS) freeMem = -1;
//    freeMem = vm_stat.free_count * page_size;
//    return [NSString stringWithFormat:@"%lld m",freeMem/(1024*1024)];
    
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    long long freeMem = 0;
    
    
    if (kernReturn != KERN_SUCCESS)
    {
        
        return 0;
    }
    
    freeMem = ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
    return [NSString stringWithFormat:@"%lld m",freeMem/(1024*1024)];
    
}

#pragma mark 获取使用的内存
- (NSString *)getUsageMemory{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    

    long long freeMem = 0;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) freeMem = -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) freeMem = -1;
    freeMem = page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
    
    return [NSString stringWithFormat:@"%lld m",freeMem/(1024*1024)];
}

#pragma mark 获取磁盘总大小  ,这里是除以1000，不是1024？
- (NSString *)getTotalDiskSpace{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    long long freeMem = 0;
    if (error) freeMem =  -1;
    freeMem =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (freeMem < 0) freeMem = -1;

    return [NSString stringWithFormat:@"%lld m",freeMem/(1000*1000)];
//
//    struct statfs buf;
//    unsigned long long freeSpace = -1;
//    if (statfs("/var", &buf) >= 0)
//    {
//        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
//    }
//    return [NSString stringWithFormat:@"%lld m",freeSpace/(1024*1024)];
}

#pragma mark 获得空闲的磁盘空间
- (NSString *)getFreeDiskSpace{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return @"";
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return [NSString stringWithFormat:@"%lld m",space/(1000*1000)];
}

#pragma mark 获得大气压
- (NSString *)getDaqiya{
    __block NSString *daqiya = nil;
    self.altimeters = [[CMAltimeter alloc]init];
    //2.检测当前设备是否可用（iphone6机型之后新增）
    if([CMAltimeter isRelativeAltitudeAvailable])
    {
        //3.开始检测气压
        
        [self.altimeters startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error) {
            
            NSString *daqi = [NSString stringWithFormat:@"高度：%.2f m  气压值：%.2f kPa",[altitudeData.relativeAltitude floatValue],[altitudeData.pressure floatValue]];
            NSLog(@"%@",daqi);
            [self.altimeters stopRelativeAltitudeUpdates];
        }];
        
    }
    
    
    
    return daqiya;
    
}

- (NSString *)getCarrierInfo{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = [info subscriberCellularProvider];
    return carrier.carrierName;
}



#pragma mark 获得音量大小（不区分系统、媒体）
//http://www.vanbein.com/posts/ios%E8%BF%9B%E9%98%B6/2015/12/24/tong-guo-dai-ma-diao-zheng-xi-tong-yin-liang-,jian-ting-yin-liang-shi-ti-an-jian/

//http://blog.csdn.net/weasleyqi/article/details/11593313
//http://www.jianshu.com/p/5a10bc48e4ec
- (void)volumeChanged:(NSNotification *)no{
    float volume = [[[no userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    self.volumeSize = [NSString stringWithFormat:@"%f",volume];
}

#pragma mark
- (NSString *)gainVolume {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    CGFloat systemVolume = audioSession.outputVolume;
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    NSLog(@"system = %.4f",systemVolume);
    
    return [NSString stringWithFormat:@"%.4f",systemVolume];
    
}

- (void)requestAudioPermission:(void(^)(BOOL success))completion
{
//    if(completion == nil) {
//        return;
//    }
//
//    AVAudioSessionRecordPermission audioStatus = [AVAudioSession sharedInstance].recordPermission;
//    if (audioStatus == AVAudioSessionRecordPermissionDenied) {// 未设置权限，提示设置
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:MIC_PROMPT_IOS8 delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//        [alert show];
//        completion(NO);
//    }
//    else if(audioStatus == AVAudioSessionRecordPermissionUndetermined){ // 第一次设置
//        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
//            if (granted) {
//                completion(YES);
//            } else {
//                completion(NO);
//            }
//        }];
//    }
//    else { //已设置权限
//        completion(YES);
//    }
}


- (NSString *)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return @"耳机插入";
    }
    return @"耳机未插入";
}

- (NSString *)isJingyin{
    
    CFStringRef state;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
    if(CFStringGetLength(state) > 0)
         return @"非静音状态";
    else
        return @"静音状态";
    
//
//    CFStringRef route;
//    UInt32 routeSize = sizeof(CFStringRef);
//
//
//    OSStatus status = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &routeSize, &route);
//    if (status == kAudioSessionNoError)
//    {
////        if (route == NULL || !CFStringGetLength(route))
////            isjingyin = TRUE;
//            return @"静音状态";
//
//
//    }
//    return @"非静音状态";
    
    
}




#pragma mark 获取运动信息状态
- (NSString * )getUserActivity{
    __block NSString *currentAc = nil;
    __block NSString *zhunquedu = nil;
    __block NSString *currentTime = nil;
    
    CMMotionActivityManager *motionActivityManager=[[CMMotionActivityManager alloc]init];
    __block NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    BOOL isAllow =  [CMMotionActivityManager isActivityAvailable];
    if (isAllow) {
        __weak typeof (self)Wself = self;
        [motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMMotionActivity * _Nullable activity) {
            currentAc = nil;
            currentTime = [dateFormater stringFromDate:[NSDate date]];
            
            if (activity.unknown) {
                currentAc = @"未知状态";
            } else if (activity.walking) {
                currentAc = @"步行";
            } else if (activity.running) {
                currentAc = @"跑步";
            } else if (activity.automotive) {
                currentAc = @"驾车";
            } else if (activity.stationary) {
                currentAc = @"静止";
            }
            
            if (activity.confidence == CMMotionActivityConfidenceLow) {
                zhunquedu = @"准确度  低";
            } else if (activity.confidence == CMMotionActivityConfidenceMedium) {
                zhunquedu = @"准确度  中";
            } else if (activity.confidence == CMMotionActivityConfidenceHigh) {
                zhunquedu = @"准确度  高";
            }
            
            currentAc = [NSString stringWithFormat:@"当前时间：%@,\n当前状态：%@,\n准确度：%@\n",currentTime,currentAc,zhunquedu];
            Wself.result = currentAc;
            
        }];
    }
    return @"";
}



#pragma mark ibeacon的demo

@end
