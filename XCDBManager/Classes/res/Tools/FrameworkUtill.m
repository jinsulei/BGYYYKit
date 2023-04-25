//
//  FrameworkUtill.m
//  BGYDBManager
//
//  Created by BGY-XC on 2023/4/24.
//

#import "FrameworkUtill.h"

@implementation FrameworkUtill

+ (NSString*)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

+ (NSTimeInterval)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;//秒
    return value;
}

+ (NSTimeInterval)daysAgo:(NSInteger)days{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [comps setDay:-days];
    NSDate *newDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    NSTimeInterval timeStamp = [newDate timeIntervalSince1970] * 1000; // *1000 是精确到毫
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timeStamp]; //转为字符型
    timeStamp = [timeString doubleValue];
    return timeStamp;
}


+ (NSTimeInterval)monthsAgo:(NSInteger)months{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [comps setMonth:-months];
    NSDate *newDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    NSTimeInterval timeStamp = [newDate timeIntervalSince1970] * 1000; // *1000 是精确到毫
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timeStamp]; //转为字符型
    timeStamp = [timeString doubleValue];
    return timeStamp;
}

+ (NSString *)accurateDateByTimeString:(NSString *)timestamp {
    if (!timestamp || timestamp.length < 13) {
        return @"";
    }
    // 时间戳转日期
    NSTimeInterval timeInterval = [timestamp doubleValue]/1000;
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 实例化一个NSDateFormatter对象，设定时间格式，这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:detailDate];
    return dateStr;
}


@end
