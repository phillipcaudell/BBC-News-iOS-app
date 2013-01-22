//
//  PPRequestKit.h
//  PowerPress
//
//  Created by Phillip Caudell on 24/10/2012.
//  Copyright (c) 2012 3SIDEDCUBE. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPCRequestKitDebugLogging YES
#define kPCRequestResponseObjectSanitation YES

@class PCRequestResponse;
@class PCRequestController;
@class PCRequest;

typedef enum {
    PPRequestContentEncodeTypeJSON = 0,
    PPRequestContentEncodeTypeForm = 1,
    PPRequestContentEncodeTypeSerialise = 2
} PPRequestContentEncodeType;

typedef enum {
    PPRequestHTTPMethodGET = 0,
    PPRequestHTTPMethodPOST = 1,
    PPRequestHTTPMethodUPDATE = 2,
    PPRequestHTTPMethodDELETE = 3
} PPRequestHTTPMethod;

typedef void (^RequestCompletionBlock)(PCRequestResponse *response, NSError *error);

@interface PCRequestController : NSObject

@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSOperationQueue *requestOperationQueue;
@property (nonatomic, assign) BOOL handleServerErrors;
@property (nonatomic, strong) NSMutableDictionary *requestHeaders;

/**
 @param baseAddress The base address at which all requests will be made from.
 */
- (id)initWithBaseAddress:(NSString *)baseAddress;

/**
 @param baseURL The base URL at which all requests will be made from.
 */
- (id)initWithBaseURL:(NSURL *)baseURL;

/**
 @param path The path which will be appended to the baseURL.
 @param params Dictionary of objects to include with the request.
 @param completionHandler Block called upon completion.
 */
- (void)get:(NSString *)path params:(NSDictionary *)params completionHandler:(RequestCompletionBlock)handler;

/**
 @param path The path which will be appended to the baseURL.
 @param params Dictionary of objects to include with the request.
 @param contentType How to post the content, as form or JSON payload.
 @param completionHandler Block called upon completion.
 */
- (void)post:(NSString *)path params:(NSDictionary *)params contentType:(PPRequestContentEncodeType)contentType completionHandler:(RequestCompletionBlock)handler;

@end

@interface PCRequest : NSOperation

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSURL *absoluteURL;
@property (nonatomic, assign) PPRequestHTTPMethod HTTPMethod;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, assign) PPRequestContentEncodeType contentEncodeType;
@property (readwrite, copy) RequestCompletionBlock completionHandler;
@property (nonatomic, weak) PCRequestController *requestController;
@property (nonatomic, strong) NSDictionary *requestHeaders;

@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, assign) BOOL isReady;
@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, assign) BOOL isConcurrent;

- (NSString *)HTTPMethodDescription:(PPRequestHTTPMethod)HTTPMethod;
- (NSString *)serialiseDictionary:(NSDictionary *)dictionary;

- (void)start;
- (void)cancel;

@end

@interface PCRequestResponse : NSObject

@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSObject *objectFromJSON;
@property (nonatomic, weak) NSDictionary *dictionaryFromJSON;
@property (nonatomic, weak) NSArray *arrayFromJSON;

- (id)initWithResponse:(NSURLResponse *)response data:(NSData *)data;
+ (NSObject *)sanitiseObject:(NSObject *)object key:(NSString *)parentKey;

@end