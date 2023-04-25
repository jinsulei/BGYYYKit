//
//  BGYFileModel.m
//  BGYUni
//
//  Created by lshenrong on 2021/11/16.
//

#import "BGYFileModel.h"

@implementation BGYFileModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
               @"contentType":@"fileContentType",
             };
}

@end
