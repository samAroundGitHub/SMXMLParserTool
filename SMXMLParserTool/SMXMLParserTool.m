//
//  SMXMLParserTool.m
//  AFNURLTestIng
//
//  Created by zzZgHhui on 16/2/28.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMXMLParserTool.h"

// 开启关闭打印, 0则关闭
#if 1 // Set to 1 to enable XML parsing logs
#define SMXMLLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define SMXMLLog(x, ...)
#endif

@interface SMXMLParserTool () <NSXMLParserDelegate>

/**
 *  标签内容
 */
@property (nonatomic, strong) NSString *characterString;
@property (nonatomic, strong) NSMutableDictionary *dictionaryM;
@property (nonatomic, strong) NSMutableArray *arrayM;

// 回调block
@property (nonatomic, copy) void (^completeHandler)(NSArray *contentArray, NSError *error);

@end

@implementation SMXMLParserTool

- (instancetype)init {
    
    if (self = [super init]) {
    }
    
    return self;
}

+ (instancetype)sm_toolWithURLString:(NSString *)urlString nodeName:(NSString *)nodeName completeHandler:(void (^)(NSArray *contentArray, NSError *error))completerHandler {
    return [[self alloc] sm_initWithURLString:urlString nodeName:nodeName completeHandler:completerHandler];
}

- (instancetype)sm_initWithURLString:(NSString *)urlString nodeName:(NSString *)nodeName completeHandler:(void (^)(NSArray *contentArray, NSError *error))completerHandler {
    
    id xmlParserTool = [super init];
    
    if (xmlParserTool) {
        [xmlParserTool loadXMLWithURLString:urlString];
        self.completeHandler = completerHandler;
        self.nodeName = nodeName;
    }
    
    return xmlParserTool;
    
}

//异步请求xml
- (void)loadXMLWithURLString:(NSString *)urlString {
    //异步请求服务器的xml文件
//    NSLog(@"%@", urlString);
    // 中文和特殊字符转码
    // NSString * encodingString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *encodingString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:encodingString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 发送异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) {
            NSLog(@"连接错误 %@",connectionError);
            return;
        }
        //
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200 || httpResponse.statusCode == 304) {
            //解析数据
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
            //设置代理
            parser.delegate = self;
            //开始执行代理的方法，代理的方法中开始解析的
            [parser parse];
        }else{
            NSLog(@"服务器内部错误");
        }
    }];
}

// 懒加载
- (NSMutableDictionary *)dictionaryM {
    if (!_dictionaryM) {
        _dictionaryM = [[NSMutableDictionary alloc] init];
    }
    return _dictionaryM;
}

- (NSMutableArray *)arrayM {
    if (!_arrayM) {
        _arrayM = [[NSMutableArray alloc] init];
    }
    return _arrayM;
}

/**
 *  返回数据
 */
- (NSArray *)contentArray {
    return self.arrayM;
}

#pragma mark NSXMLParserDelegate

/**
 *  开始解析文档
 */
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    SMXMLLog(@"<Doc>");
}

/**
 *  开始解析节点
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    SMXMLLog(@"-<%@>",elementName);
}

/**
 *  解析节点内容
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    // 拼接完整节点内容
    if (self.characterString) {
        self.characterString = [NSString stringWithFormat:@"%@%@",self.characterString,string];
    }else {
        self.characterString = string;
    }}

/**
 *  结束解析节点
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    SMXMLLog(@"%@", self.characterString);
    SMXMLLog(@"-</%@>", elementName);

    if (self.characterString) {
        [self.dictionaryM setObject:self.characterString forKey:elementName];
        self.characterString = nil;
    }
    if ([elementName isEqualToString:self.nodeName]) {
        
        [self.arrayM addObject:[self.dictionaryM copy]];
        [self.dictionaryM removeAllObjects];
    }
}

/**
 *  结束解析文档
 */
- (void)parserDidEndDocument:(NSXMLParser *)parser {
     SMXMLLog(@"</Doc>");

    self.characterString = nil;
    self.dictionaryM = nil;
    
    
    // 执行block
    self.completeHandler(self.arrayM, nil);
}

/**
 *  解析错误
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"%@", [parseError description]);
    
    // 执行block
    self.completeHandler(self.arrayM, parseError);
}

@end
