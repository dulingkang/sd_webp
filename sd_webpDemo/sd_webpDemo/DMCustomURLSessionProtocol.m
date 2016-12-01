//
//  DMCustomURLSessionProtocol.m
//  DemoCollectOC
//
//  Created by ShawnDu on 16/6/22.
//  Copyright © 2016年 Shawn.Du. All rights reserved.
//

#import "DMCustomURLSessionProtocol.h"
#import <UIImage+MultiFormat.h>

static NSString *URLProtocolHandledKey = @"URLHasHandle";

@interface DMCustomURLSessionProtocol()<NSURLSessionDelegate,NSURLSessionDataDelegate>

@property (nonatomic,strong) NSURLSession *session;
@property (strong, nonatomic) NSMutableData *imageData;
@property (nonatomic) BOOL beginAppendData;

@end

@implementation DMCustomURLSessionProtocol

#pragma mark - 初始化请求

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( (([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame)) && ([[request.URL absoluteString] hasSuffix:@"webp"]))
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

#pragma mark - 通信协议内容实现

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //标示改request已经处理过了，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableReqeust];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue currentQueue]];
    [[self.session dataTaskWithRequest:mutableReqeust] resume];
    
}


- (void)stopLoading
{
    [self.session invalidateAndCancel];
    self.session = nil;
}

#pragma mark - dataDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSMutableURLRequest *    redirectRequest;
    
    redirectRequest = [newRequest mutableCopy];
    [[self class] removePropertyForKey:URLProtocolHandledKey inRequest:redirectRequest];

    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
    
    [self.session invalidateAndCancel];
    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    NSInteger expected = response.expectedContentLength > 0 ? (NSInteger)response.expectedContentLength : 0;
    self.imageData = [[NSMutableData alloc] initWithCapacity:expected];
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{

    if ([dataTask.currentRequest.URL.absoluteString hasSuffix:@"webp"]) {
        self.beginAppendData = YES;
        [self.imageData appendData:data];
    }
    if (!_beginAppendData) {
        //TODO:- GM Crash
        [self.client URLProtocol:self didLoadData:data];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error{
    
    if (error == nil) {
        if ([task.currentRequest.URL.absoluteString hasSuffix:@"webp"]) {
            NSLog(@"webp will changed:%@",task.currentRequest.URL);
            UIImage *imgData = [UIImage sd_imageWithData:self.imageData];
            NSData *transData = UIImageJPEGRepresentation(imgData, 0.8f);
            self.beginAppendData = NO;
            self.imageData = nil;
            [self.client URLProtocol:self didLoadData:transData];
        }
        [self.client URLProtocolDidFinishLoading:self];
    } else if ( [[error domain] isEqual:NSURLErrorDomain] && ([error code] == NSURLErrorCancelled) ) {
        [self.client URLProtocol:self didFailWithError:error];
    }else{
        [[self client] URLProtocol:self didFailWithError:error];
    }
}

@end
