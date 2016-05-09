//
//  CommonTool.m
//  AlgorithmDemo
//
//  Created by LIKUN on 15/7/24.
//  Copyright (c) 2015年 LIKUN. All rights reserved.
//

#import "ToolKit.h"

@implementation ToolKit

#pragma mark - 设备信息
+ (NSString *)getBuildVersion
{
    NSString *infoPlistPath = [ [NSBundle mainBundle] pathForResource:@"Info"ofType:@"plist"];
    NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:infoPlistPath];
    
    return [infoDic objectForKey:@"CFBundleVersion"];
}

+ (NSString *)getVersionNum
{
    NSDictionary *bundleDic = [[NSBundle mainBundle] infoDictionary];
    NSString *versionNum = [bundleDic objectForKey:@"CFBundleShortVersionString"];//CFBundleShortVersionString
    return versionNum;
}

+ (NSString *)getBundleIdentifier
{
    NSDictionary *bundleDic = [[NSBundle mainBundle] infoDictionary];
    NSString *Identifier = [bundleDic objectForKey:@"CFBundleIdentifier"];
    return Identifier;
}

+(NSString*) getDeviceSystemName
{
    return [[UIDevice currentDevice] systemName];
}

+(NSString*) getDeviceSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark - 打电话
+ (void)callTelephoneNumber:(NSString *)num addView:(UIView *)view
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-6507265"]];
}

#pragma mark - JSON转换
+ (NSString *)JSONEncodeFromDictionary:(NSMutableDictionary *)dic
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if ([jsonStr length] ==0 )
    {
        jsonStr = @"";
    }
    return jsonStr;
}

+ (id)JSONDecodeFromString:(NSString *)string
{
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
}

#pragma mark - 类属性相关
const char * getPropertyType(objc_property_t property)
{
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL)
    {
        if (attribute[0] == 'T' && attribute[1] != '@')
        {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2)
        {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@')
        {
            // it's another ObjC object type:
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}

+(NSArray *)getAllPropertysWithClassName:(NSString *)objectName
{
    NSMutableArray *mutArray=[NSMutableArray arrayWithCapacity:0];
    unsigned int _outCount ;
    const char *_className_C = [objectName UTF8String];
    id propertyCustomer = objc_getClass(_className_C);
    
    objc_property_t *const _properties = class_copyPropertyList(propertyCustomer, &_outCount);
    objc_property_t * _pProperty = _properties;
    for (NSInteger _i = _outCount -1; _i >= 0; _i--, _pProperty++) {
        NSString *_getPropertyName = [NSString stringWithCString:property_getName(*_pProperty) encoding:NSUTF8StringEncoding];
        [mutArray addObject:_getPropertyName];
        
    }
    return [NSArray arrayWithArray:mutArray];
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (CGSize)getSizeByFont:(UIFont *)font labelWidth:(CGFloat)width message:(NSString *)msg
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize retSize = [msg boundingRectWithSize:CGSizeMake(width-20*2, 0)
                                       options:
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    return retSize;
    
}
+ (NSString *) phonetic:(NSString*)sourceString {
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *retSting = [source stringByReplacingOccurrencesOfString:@" " withString:@""];
    return retSting;
}

+ (NSString *)nowTimeStamp
{
    NSDate *dateNow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%f", [dateNow timeIntervalSince1970]];
    return timeSp;
}

+ (float)intervalFromStamp:(NSString *)stmp1 toStamp:(NSString *)stmp2
{
    CGFloat stp1 = [stmp1 floatValue];
    CGFloat stp2 = [stmp2 floatValue];
    
    float days = (stp2 -stp1)/3600.0/24.0;
    return days;
}

+ (NSString *)dateToNYRString:(NSDate *)date{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    return [dateFormater stringFromDate:date];
}

+ (NSString *)dateToNString:(NSDate *)date
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy"];
    return [dateFormater stringFromDate:date];
}

+ (NSString *)dateToYString:(NSDate *)date
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"MM"];
    return [dateFormater stringFromDate:date];
}

+ (CGFloat)getHeightWithString:(NSString *)fullDescAndTagStr font:(UIFont *)font labelWidth:(CGFloat)labelWidth
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.firstLineHeadIndent = 0;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [fullDescAndTagStr boundingRectWithSize:CGSizeMake(labelWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    
    return labelSize.height+2;
}
+ (CGFloat) widthWithFont:(UIFont *)font height:(CGFloat)height text:(NSString *)text{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(0, height) options: NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size.width;
}

// 检测网络
static BOOL ischecked = NO;
+ (AFNetworkReachabilityStatus)checkNetwork
{
    __block AFNetworkReachabilityStatus statusInNet = AFNetworkReachabilityStatusUnknown;
    if (ischecked == NO)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            ischecked = YES;
        });
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_async(group, queue, ^{
            
            /**
             AFNetworkReachabilityStatusUnknown          = -1,  // 未知
             AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
             AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
             AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
             */
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            [[AFNetworkReachabilityManager sharedManager] startMonitoring];
            [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                statusInNet = status;
                
                dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        });
    }
    return statusInNet;
}
// 检测网络
static BOOL ischeckedSuccess = NO;
+ (void)checkNetworkStatue:(void(^)(AFNetworkReachabilityStatus statue))block
{
    __block AFNetworkReachabilityStatus statusInNet = AFNetworkReachabilityStatusUnknown;
    if (ischeckedSuccess == NO)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            ischeckedSuccess = YES;
        });
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_group_async(group, queue, ^{
            
            /**
             AFNetworkReachabilityStatusUnknown          = -1,  // 未知
             AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
             AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
             AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
             */
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            [[AFNetworkReachabilityManager sharedManager] startMonitoring];
            [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                statusInNet = status;
                block(statusInNet);
                dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        });
    }
}

//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    size_t size;
    
    int nR = sysctlbyname("hw.machine",
                          NULL, &size, NULL,
                          0);
    
    char*machine = (char*)malloc(size);
    
    nR =sysctlbyname("hw.machine", machine, &size,
                 NULL, 0);
    
    NSString *platform = [NSString
                          stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
+ (BOOL)checkDeviceSupportECar
{
    size_t size;
    int nR = sysctlbyname("hw.machine",
                          NULL, &size, NULL,
                          0);
    char*machine = (char*)malloc(size);
    nR =sysctlbyname("hw.machine", machine, &size,
                     NULL, 0);
    NSString *platform = [NSString
                          stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);

    if ([platform isEqualToString:@"iPhone1,1"]) return NO;
    if ([platform isEqualToString:@"iPhone1,2"]) return NO;
    if ([platform isEqualToString:@"iPhone2,1"]) return NO;
    if ([platform isEqualToString:@"iPhone3,1"]) return NO;
    if ([platform isEqualToString:@"iPhone3,2"]) return NO;
    if ([platform isEqualToString:@"iPhone3,3"]) return NO;
    if ([platform isEqualToString:@"iPhone4,1"]) return NO;
    if ([platform isEqualToString:@"iPhone5,1"]) return NO;
    if ([platform isEqualToString:@"iPhone5,2"]) return NO;
    if ([platform isEqualToString:@"iPhone5,3"]) return NO;
    if ([platform isEqualToString:@"iPhone5,4"]) return NO;
    if ([platform isEqualToString:@"iPhone6,1"]) return YES;
    if ([platform isEqualToString:@"iPhone6,2"]) return YES;
    if ([platform isEqualToString:@"iPhone7,1"]) return YES;
    if ([platform isEqualToString:@"iPhone7,2"]) return YES;
    if ([platform isEqualToString:@"iPhone8,1"]) return YES;
    if ([platform isEqualToString:@"iPhone8,2"]) return YES;
    
    return NO;
}

+ (NSString *)nullString:(NSString *)str
{
    if (str == nil)
    {
        return @"";
    }
    
    if (![str isKindOfClass:[NSString class]])
    {
        return [NSString stringWithFormat:@"%@",str];
    }
    
    if ([str isKindOfClass:[NSNull class]] || str.length == 0)
    {
        str = @"";
    }
    return str;
}
@end
