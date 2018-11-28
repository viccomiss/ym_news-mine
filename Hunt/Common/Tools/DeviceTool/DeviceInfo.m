//
//  DeviceInfo.m
//  SuperEducation
//
//  Created by wangcl on 2017/6/13.
//  Copyright © 2017年 luoqi. All rights reserved.
//

#import "DeviceInfo.h"
#import "sys/utsname.h"
#include <mach/mach.h>
#import "SAMKeychain.h"
#import <ifaddrs.h>
#import <resolv.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <netdb.h>
#import <netinet/ip.h>
#import <net/ethernet.h>
#import <net/if_dl.h>


#define OpenSessionID @"uuid"
#define MDNS_PORT       5353
#define QUERY_NAME      "_apple-mobdev2._tcp.local"
#define DUMMY_MAC_ADDR  @"02:00:00:00:00:00"
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation DeviceInfo

/*
 * 获取设备物理地址
 */
+ (nullable NSString *)getMacAddress {
    res_9_init();
    int len;
    //get currnet ip address
    NSString *ip = [self currentIPAddressOf:IOS_WIFI];
    if(ip == nil) {
        fprintf(stderr, "could not get current IP address of en0\n");
        return DUMMY_MAC_ADDR;
    }//end if
    
    //set port and destination
    _res.nsaddr_list[0].sin_family = AF_INET;
    _res.nsaddr_list[0].sin_port = htons(MDNS_PORT);
    _res.nsaddr_list[0].sin_addr.s_addr = [self IPv4Pton:ip];
    _res.nscount = 1;
    
    unsigned char response[NS_PACKETSZ];
    
    
    //send mdns query
    if((len = res_9_query(QUERY_NAME, ns_c_in, ns_t_ptr, response, sizeof(response))) < 0) {
        
        fprintf(stderr, "res_search(): %s\n", hstrerror(h_errno));
        return DUMMY_MAC_ADDR;
    }//end if
    
    //parse mdns message
    ns_msg handle;
    if(ns_initparse(response, len, &handle) < 0) {
        fprintf(stderr, "ns_initparse(): %s\n", hstrerror(h_errno));
        return DUMMY_MAC_ADDR;
    }//end if
    
    //get answer length
    len = ns_msg_count(handle, ns_s_an);
    if(len < 0) {
        fprintf(stderr, "ns_msg_count return zero\n");
        return DUMMY_MAC_ADDR;
    }//end if
    
    //try to get mac address from data
    NSString *macAddress = nil;
    for(int i = 0 ; i < len ; i++) {
        ns_rr rr;
        ns_parserr(&handle, ns_s_an, 0, &rr);
        
        if(ns_rr_class(rr) == ns_c_in &&
           ns_rr_type(rr) == ns_t_ptr &&
           !strcmp(ns_rr_name(rr), QUERY_NAME)) {
            char *ptr = (char *)(ns_rr_rdata(rr) + 1);
            int l = (int)strcspn(ptr, "@");
            
            char *tmp = calloc(l + 1, sizeof(char));
            if(!tmp) {
                perror("calloc()");
                continue;
            }//end if
            memcpy(tmp, ptr, l);
            macAddress = [NSString stringWithUTF8String:tmp];
            free(tmp);
        }//end if
    }//end for each
    macAddress = macAddress ? macAddress : DUMMY_MAC_ADDR;
    return macAddress;
}//end getMacAddressFromMDNS

+ (nonnull NSString *)currentIPAddressOf: (nonnull NSString *)device {
    struct ifaddrs *addrs;
    NSString *ipAddress = nil;
    
    if(getifaddrs(&addrs) != 0) {
        return nil;
    }//end if
    
    //get ipv4 address
    for(struct ifaddrs *addr = addrs ; addr ; addr = addr->ifa_next) {
        if(!strcmp(addr->ifa_name, [device UTF8String])) {
            if(addr->ifa_addr) {
                struct sockaddr_in *in_addr = (struct sockaddr_in *)addr->ifa_addr;
                if(in_addr->sin_family == AF_INET) {
                    ipAddress = [self IPv4Ntop:in_addr->sin_addr.s_addr];
                    break;
                }//end if
            }//end if
        }//end if
    }//end for
    
    freeifaddrs(addrs);
    return ipAddress;
}//end currentIPAddressOf:

+ (nullable NSString *)IPv4Ntop: (in_addr_t)addr {
    char buffer[INET_ADDRSTRLEN] = {0};
    return inet_ntop(AF_INET, &addr, buffer, sizeof(buffer)) ?
    [NSString stringWithUTF8String:buffer] : nil;
}//end IPv4Ntop:

+ (in_addr_t)IPv4Pton: (nonnull NSString *)IPAddr {
    in_addr_t network = INADDR_NONE;
    return inet_pton(AF_INET, [IPAddr UTF8String], &network) == 1 ?
    network : INADDR_NONE;
}//end IPv4Pton:


+ (NSString *)getUUID
{
    NSString  *openUUID = [[NSUserDefaults standardUserDefaults] objectForKey:OpenSessionID];
    if (openUUID == nil || [openUUID isEqualToString:@""]) {
        openUUID = [SAMKeychain passwordForService:@" "account:OpenSessionID];
        if (openUUID == nil || [openUUID isEqualToString:@""]) {
            NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
            openUUID = currentDeviceUUID.UUIDString;
            openUUID = [openUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
            openUUID = [openUUID lowercaseString];
            //存到钥匙串
            [SAMKeychain setPassword: openUUID forService:@" "account:@"uuid"];
        }
        //存到沙盒
        [[NSUserDefaults standardUserDefaults] setObject:openUUID forKey:OpenSessionID];
        [[NSUserDefaults  standardUserDefaults] synchronize];
    }
    return openUUID;
}

// 获取设备型号然后手动转化为对应名称
+ (NSString *)getDeviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceString isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}

- (NSDate *)getSystemUptime {
    NSTimeInterval time = [[NSProcessInfo processInfo] systemUptime];
    return [[NSDate alloc] initWithTimeIntervalSinceNow:(0 - time)];
}
// CPU总数目
+ (NSUInteger)getCPUCount {
    return [NSProcessInfo processInfo].activeProcessorCount;
}
#pragma mark - Disk
- (int64_t)getTotalDiskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)getFreeDiskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)getUsedDiskSpace {
    int64_t totalDisk = [self getTotalDiskSpace];
    int64_t freeDisk = [self getFreeDiskSpace];
    if (totalDisk < 0 || freeDisk < 0) return -1;
    int64_t usedDisk = totalDisk - freeDisk;
    if (usedDisk < 0) usedDisk = -1;
    return usedDisk;
}

#pragma mark - 内存相关
+ (int64_t)getTotalMemory {
    int64_t totalMemory = [[NSProcessInfo processInfo] physicalMemory];
    if (totalMemory < -1) totalMemory = -1;
    return totalMemory;
}

+ (int64_t)getActiveMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.active_count * page_size;
}

+ (int64_t)getInActiveMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.inactive_count * page_size;
}

+ (int64_t)getFreeMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.free_count * page_size;
}

+ (int64_t)getUsedMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
}

+ (int64_t)getWiredMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.wire_count * page_size;
}

+ (int64_t)getPurgableMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.purgeable_count * page_size;
}
@end
