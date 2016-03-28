# SMXMLParserTool

轻量级XML解析工具

SAX解析

类方法
+ (instancetype)sm_toolWithURLString:(NSString *)urlString nodeName:(NSString *)nodeName completeHandler:(void (^)(NSArray *contentArray, NSError *error))completerHandler;
传入url地址, node节点, block返回结果contentArray直接使用即可.
