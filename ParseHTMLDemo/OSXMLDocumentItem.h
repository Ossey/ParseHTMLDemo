//
//  OSXMLDocumentItem.h
//  ParseHTMLDemo
//
//  Created by Swae on 2017/11/12.
//  Copyright © 2017年 Ossey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSXMLDocumentItem : NSObject

@property (nonatomic, strong) NSArray *videoURLs;
@property (nonatomic, strong) NSArray *imageURLs;

+ (instancetype)parseElementWithURL:(NSURL *)url;
+ (instancetype)parseElementWithHTMLString:(NSString *)htmlString;

@end
