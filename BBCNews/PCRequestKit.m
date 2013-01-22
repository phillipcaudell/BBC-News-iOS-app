//
//  PPRequestKit.m
//  PowerPress
//
//  Created by Phillip Caudell on 24/10/2012.
//  Copyright (c) 2012 3SIDEDCUBE. All rights reserved.
//

#import "PCRequestKit.h"

@implementation PCRequestController

- (id)init
{
    self = [super init];
    if (self) {
        
        self.requestHeaders = [[NSMutableDictionary alloc] init];
        self.requestOperationQueue = [[NSOperationQueue alloc] init];
        self.requestOperationQueue.maxConcurrentOperationCount = 20;
        _handleServerErrors = YES;
        
    }
    return self;
}

/**
 @param baseAddress The base address at which all requests will be made from.
 */
- (id)initWithBaseAddress:(NSString *)baseAddress
{
    self = [self init];
    if (self) {
        self.baseURL = [NSURL URLWithString:baseAddress];
    }
    return self;
}

/**
 @param baseURL The base URL at which all requests will be made from.
 */
- (id)initWithBaseURL:(NSURL *)baseURL
{
    self = [self init];
    if (self) {
        self.baseURL = baseURL;
    }
    return self;
}

/**
 @param path The path which will be appended to the baseURL.
 @param params Dictionary of objects to include with the request.
 @param completionHandler Block called upon completion.
 */
- (void)get:(NSString *)path params:(NSDictionary *)params completionHandler:(RequestCompletionBlock)handler
{
    PCRequest *request = [[PCRequest alloc] init];
    request.baseURL = _baseURL;
    request.path = path;
    request.params = params;
    request.completionHandler = handler;
    request.HTTPMethod = PPRequestHTTPMethodGET;
    request.requestController = self;
    request.requestHeaders = self.requestHeaders;
    [request setIsReady:YES];
    [_requestOperationQueue addOperation:request];
}

/**
 @param path The path which will be appended to the baseURL.
 @param params Dictionary of objects to include with the request.
 @param contentType How to post the content, as form or JSON payload.
 @param completionHandler Block called upon completion.
 */
- (void)post:(NSString *)path params:(NSDictionary *)params contentType:(PPRequestContentEncodeType)contentType completionHandler:(RequestCompletionBlock)handler
{
    PCRequest *request = [[PCRequest alloc] init];
    request.baseURL = _baseURL;
    request.path = path;
    request.params = params;
    request.completionHandler = handler;
    request.contentEncodeType = contentType;
    request.HTTPMethod = PPRequestHTTPMethodPOST;
    request.requestController = self;
    request.requestHeaders = self.requestHeaders;
    [request setIsReady:YES];
    [_requestOperationQueue addOperation:request];
}

@end

@implementation PCRequest


- (id)init
{
    self = [super init];
    if (self) {
        self.isConcurrent = YES;
    }
    return self;
}

- (NSURL *)absoluteURL
{
    NSString *baseURL;
    
    if (self.URL) {
        baseURL = [self.URL absoluteString];
    } else {
        baseURL = [NSString stringWithFormat:@"%@/%@", _baseURL, _path];
    }
    
    if (_HTTPMethod == PPRequestHTTPMethodGET && _params) {
        return [NSURL URLWithString:[baseURL stringByAppendingString:[self serialiseDictionary:_params]]];
    } else {
        return [NSURL URLWithString:baseURL];
    }
}

- (NSString *)serialiseDictionary:(NSDictionary *)dictionary
{
    NSString *serialisedString = [NSString string];
    NSArray *dictionaryKeys = [dictionary allKeys];
    
    for (NSString *key in dictionaryKeys){
        
        NSInteger keyIndex = [dictionaryKeys indexOfObject:key];
        
        NSString *sanitisedString = nil;
        
        if ([[dictionary objectForKey:key] isKindOfClass:[NSNumber class]]) {
            sanitisedString = [(NSNumber *)[dictionary objectForKey:key] stringValue];
        } else {
            sanitisedString = (NSString *)[dictionary objectForKey:key];
        }
        
        sanitisedString = [sanitisedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if (keyIndex == 0) {
            serialisedString = [serialisedString stringByAppendingFormat:@"?%@=%@", key, sanitisedString];
        } else {
            serialisedString = [serialisedString stringByAppendingFormat:@"&%@=%@", key, sanitisedString];
        }
    }
    
    return serialisedString;
}

- (void)start
{
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self absoluteURL]];
    
    request.HTTPMethod = [self HTTPMethodDescription:_HTTPMethod];
    
    // Set HTTP headers
    for (NSString *key in [self.requestHeaders allKeys]){
        [request setValue:self.requestHeaders[key] forHTTPHeaderField:key];
    }
    
    if (self.HTTPMethod == PPRequestHTTPMethodPOST) {
        
        if (self.contentEncodeType == PPRequestContentEncodeTypeJSON) {
            
            request.HTTPBody = [NSJSONSerialization dataWithJSONObject:self.params options:NSJSONWritingPrettyPrinted error:nil];
        }
        
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        PCRequestResponse *requestResponse = [[PCRequestResponse alloc] initWithResponse:response data:data];
            
        // Any server errors?
        if (!error && _requestController.handleServerErrors) {
            if (requestResponse.status >= 500 && requestResponse.status < 600) {
                error = [NSError errorWithDomain:nil code:requestResponse.status userInfo:@{ NSLocalizedDescriptionKey : @"Server error occured" }];
            }
        }
        
        _completionHandler(requestResponse,error);
        
        [self willChangeValueForKey:@"isExecuting"];
        _isExecuting = NO;
        [self didChangeValueForKey:@"isExecuting"];
        
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
        
    }];
    
    if (kPCRequestKitDebugLogging) {
        NSLog(@"%@", self);
    }
}

- (NSString *)HTTPMethodDescription:(PPRequestHTTPMethod)HTTPMethod
{
    switch (HTTPMethod) {
        case PPRequestHTTPMethodGET:
            return @"GET";
            break;
        case PPRequestHTTPMethodPOST:
            return @"POST";
            break;
        case PPRequestHTTPMethodUPDATE:
            return @"UPDATE";
            break;
        case PPRequestHTTPMethodDELETE:
            return @"DELETE";
            break;
        default:
            return nil;
            break;
    }
}

- (void)cancel
{
    [self willChangeValueForKey:@"isCanceled"];
    _isCanceled = YES;
    [self didChangeValueForKey:@"isCanceled"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<PCRequest | %@>", [self absoluteURL]];
}

@end

@implementation PCRequestResponse

- (NSString *)description
{
    return [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
}

- (id)initWithResponse:(NSURLResponse *)response data:(NSData *)data
{
    self = [super init];
    if (self) {
        
        _data = data;
        
        if ([response respondsToSelector:@selector(statusCode)]) {
            _status = [(NSHTTPURLResponse *)response statusCode];
            _headers = [(NSHTTPURLResponse *)response allHeaderFields];
        }
        
    }
    return self;
}

- (NSDictionary *)dictionaryFromJSON
{
    return (NSDictionary *)[self objectFromJSON];
}

- (NSArray *)arrayFromJSON
{
    return (NSArray *)[self objectFromJSON];
}

- (NSObject *)objectFromJSON
{
    if (!_objectFromJSON) {
        if (kPCRequestResponseObjectSanitation) {
            _objectFromJSON = [PCRequestResponse sanitiseObject:[NSJSONSerialization JSONObjectWithData:_data options:0 error:nil] key:nil];
        } else {
            _objectFromJSON = [NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
        }
    }
    return _objectFromJSON;
}

/**
 Removes NSNull from the dictionary / array by not including it, thus giving us regular nil.
 */
+ (NSObject *)sanitiseObject:(NSObject *)object key:(NSString *)parentKey
{
    if ([object isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        
        for (NSObject *arrayObject in (NSArray *)object){
            
            NSObject *sanitisedObject = [PCRequestResponse sanitiseObject:arrayObject key:parentKey];
            if (sanitisedObject) {
                [mutableArray addObject:sanitisedObject];
            }
            
        }
        
        return mutableArray;
        
    } else if ([object isKindOfClass:[NSDictionary class]]){
        
        NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
        
        NSArray *allKeys = [(NSDictionary *)object allKeys];
        
        for (NSString *key in allKeys){
            
            NSObject *keyObject = [(NSDictionary *)object objectForKey:key];
            if (keyObject) {
                
                NSObject *sanitisedObject = [PCRequestResponse sanitiseObject:keyObject key:key];
                
                if (sanitisedObject) {
                    [mutableDictionary setObject:sanitisedObject forKey:key];
                }
            }
        }
        
        return mutableDictionary;
        
    } else {
        
        if ([object isEqual:[NSNull null]]) {
            return nil;
        } else {
            return object;
        }
        
    }
}


@end