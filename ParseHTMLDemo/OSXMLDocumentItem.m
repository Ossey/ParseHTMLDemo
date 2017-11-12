//
//  OSXMLDocumentItem.m
//  ParseHTMLDemo
//
//  Created by Swae on 2017/11/12.
//  Copyright © 2017年 Ossey. All rights reserved.
//

#import "OSXMLDocumentItem.h"
#import <Ono.h>

@interface OSXMLDocumentItem () {
    NSURL *_currentURL;
    NSString *_htmlString;
}

@end

@implementation OSXMLDocumentItem

+ (instancetype)parseElementWithURL:(NSURL *)url {
    
    OSXMLDocumentItem *item = [[self alloc] initWithURL:url];;
    return item;
}

+ (instancetype)parseElementWithHTMLString:(NSString *)htmlString {
    OSXMLDocumentItem *item = [[self alloc] initWithHtmlString:htmlString];
    return item;
}

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        _currentURL = url;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithHtmlString:(NSString *)htmlString {
    if (self = [super init]) {
        _htmlString = htmlString;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self parseVideoURLsByURL];
    [self parseVideoURLsByHTMLString];
}

/// 根据UR串提取HTML中的视频
- (void)parseVideoURLsByURL {
    if (!_currentURL) {
        return;
    }
    NSMutableArray *videoURLs = [NSMutableArray array];
    NSData *data= [NSData dataWithContentsOfURL:_currentURL];
    
    NSError *error;
    ONOXMLDocument *doc= [ONOXMLDocument HTMLDocumentWithData:data error:&error];
    if (error || !doc) {
        return;
    }
    // 此解析主要用于提取"https://www.8863h.com/Html/110/index-3.html"中的视频
    [doc enumerateElementsWithXPath:@".//ul[@class='downurl']/a" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        
        ///
        NSString *downurl = [element valueForAttribute:@"href"];
        if (downurl.length) {
            [videoURLs addObject:downurl];
        }
    }];
    
    self.videoURLs = videoURLs;
}

/// 根据HTML字符串提取HTML中的视频
- (void)parseVideoURLsByHTMLString {
    if (!_htmlString.length) {
        return;
    }
    NSMutableArray *videoURLs = [NSMutableArray array];
    NSError *error;
    ONOXMLDocument *doc= [ONOXMLDocument HTMLDocumentWithString:_htmlString encoding:NSUTF8StringEncoding error:&error];
    if (error || !doc) {
        return;
    }
    [doc enumerateElementsWithXPath:@".//ul[@class='downurl']/a" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        
        ///
        NSString *downurl = [element valueForAttribute:@"href"];
        if (downurl.length) {
            [videoURLs addObject:downurl];
        }
    }];
    
    self.videoURLs = videoURLs;
}


/// 根据url提取网页中的图片
- (void)parseImageURLsByURL {
    if (!_currentURL) {
        return;
    }

    NSMutableArray *imageURLs= [NSMutableArray array];
    NSData *data = [NSData dataWithContentsOfURL:_currentURL];
    
    NSError *error;
    ONOXMLDocument *doc= [ONOXMLDocument HTMLDocumentWithData:data error:&error];
    if (error || !doc) {
        return;
    }
    [doc enumerateElementsWithXPath:@".//div" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        /// 提取每个子节点的图片img
        NSArray *imgArr = [element childrenWithTag:@"img"];
        if (imgArr.count) {
            [imgArr enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *img = [element valueForAttribute:@"src"];
                if (img.length) {
                    [imageURLs addObject:img];
                }
            }];
            
        }
    }];
    
    self.imageURLs = imageURLs;
}

/// 根据HTML字符串提取HTML中的图片
- (void)parseImageURLsByHTMLString {
    if (!_htmlString.length) {
        return;
    }
    
    NSMutableArray *imageURLs= [NSMutableArray array];
    NSError *error;
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithString:_htmlString encoding:NSUTF8StringEncoding error:&error];
    if (error || !doc) {
        return;
    }
    [doc enumerateElementsWithXPath:@".//div" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        /// 提取每个子节点的图片img
        NSArray *imgArr = [element childrenWithTag:@"img"];
        if (imgArr.count) {
            [imgArr enumerateObjectsUsingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *img = [element valueForAttribute:@"src"];
                if (img.length) {
                    [imageURLs addObject:img];
                }
            }];
            
        }
    }];
    
    self.imageURLs = imageURLs;
}

@end

