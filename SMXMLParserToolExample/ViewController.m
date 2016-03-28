//
//  ViewController.m
//  SMXMLParserToolExample
//
//  Created by zzZgHhui on 16/3/28.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "ViewController.h"
#import "SMXMLParserTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 可在.m文件开启关闭SMXMLLog打印
    [SMXMLParserTool sm_toolWithURLString:@"http://wcf.open.cnblogs.com/news/hot/1" nodeName:@"entry" completeHandler:^(NSArray *contentArray, NSError *error) {
        if (!error) {
//            NSLog(contentArray);
        }
    }];
}

@end
