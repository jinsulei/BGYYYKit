//
//  FrameworkUtill.h
//  BGYDBManager
//
//  Created by BGY-XC on 2023/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrameworkUtill : NSObject

#pragma mark - time
+ (NSString*)getCurrentTime;
+ (NSTimeInterval)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

+ (NSTimeInterval)monthsAgo:(NSInteger)months;
+ (NSTimeInterval)daysAgo:(NSInteger)days;
+ (NSString *)accurateDateByTimeString:(NSString *)timestamp;

@end

NS_ASSUME_NONNULL_END
