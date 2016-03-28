//
//  SMXMLParserTool.h
//  AFNURLTestIng
//
//  Created by zzZgHhui on 16/2/28.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMXMLParserTool : NSObject

+ (instancetype)sm_toolWithURLString:(NSString *)urlString nodeName:(NSString *)nodeName completeHandler:(void (^)(NSArray *contentArray, NSError *error))completerHandler;
- (instancetype)sm_initWithURLString:(NSString *)urlString nodeName:(NSString *)nodeName completeHandler:(void (^)(NSArray *contentArray, NSError *error))completerHandler;

/*
+ (instancetype)sm_toolWithURLData:(NSData *)urlData completeHandler:(void (^)(NSArray *contentArray))completerHandler;
- (instancetype)sm_initWithURLData:(NSData *)urlData completeHandler:(void (^)(NSArray *contentArray))completerHandler;
*/

@property (nonatomic, readonly, strong) NSArray *contentArray;
@property (nonatomic, strong) NSString *nodeName;

@end
