//
//  BGYPileDynamicFormModel.h
//  BGYUni
//
//  Created by BGY on 2023/2/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface BGYPileDynamicFormModel : NSObject
@property(nonatomic ,copy) NSString *id;
@property(nonatomic ,copy) NSString *pileId;
@property(nonatomic ,copy) NSString *pilingRecordId;
@property(nonatomic ,copy) NSString *itemGroupName;
@property(nonatomic ,copy) NSString *itemGroupCode;
@property(nonatomic ,copy) NSString *parentId;
@property(nonatomic ,copy) NSString *parentId2;
@property(nonatomic ,copy) NSString *fullCode;
//是否必填
@property(nonatomic ,assign) NSInteger mustNotNull;
//启用状态
@property(nonatomic ,copy) NSString *status;
//序号
@property(nonatomic ,assign) NSInteger num;
@property(nonatomic ,assign) NSInteger num2;
//字段展示名称
@property(nonatomic ,copy) NSString *fieldName;
//字段编码
@property(nonatomic ,copy) NSString *fieldCode;
//字段描述
@property(nonatomic ,copy) NSString *fieldDescribe;
//字段类型
@property(nonatomic ,copy) NSString *fieldType;
//字段选择的内容,单选或者多选{"1":"中文"}
@property(nonatomic ,copy) NSString *fieldSelectParams;
//计算值计算公式
@property(nonatomic ,copy) NSString *fieldFormula;
//字段长度[4,2]
@property(nonatomic ,copy) NSString *fieldLength;
//字段后缀描述
@property(nonatomic ,copy) NSString *fieldSuffixDescribe;
//取值范围
@property(nonatomic ,copy) NSString *valueRange;
//原字段值（修改使用）
@property(nonatomic ,copy) NSString *oldFieldValue;
//审批状态
@property(nonatomic ,copy) NSString *auditStatus;
//最大可以重复的次数，1表示不重复
@property(nonatomic ,assign) NSInteger repeatMax;
//可以编辑的角色/类型["",""]
@property(nonatomic ,copy) NSString *editRoles;
@property(nonatomic ,copy) NSString *fieldValue;
@property(nonatomic ,copy) NSString *tempValue;
//是否存在修改（修改使用）
//@property(nonatomic ,assign) BOOL hasUpdate;
@property(nonatomic ,copy) NSString *hasUpdate;
//排序数量（相同组递增，从1开始）
@property(nonatomic ,assign) NSInteger orderNum;
@property(nonatomic ,assign) NSInteger orderNum2;
@property(nonatomic ,copy) NSString *createTime;
@property(nonatomic ,copy) NSString *type;
@property(nonatomic ,copy) NSString *pid;
@end

NS_ASSUME_NONNULL_END
