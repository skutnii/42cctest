//
//  SKCallExecutor.m
//  ioswlc
//
//  Created by Serge Kutny on 1/18/13.
//  Copyright (c) 2013 BITP. All rights reserved.
//

#import "SKCallExecutor.h"
#import "NSDictionary+URLParameters.h"
#import "SBJson.h"
#import "SKDataProcessor.h"
#import "TSKRequestException.h"

@implementation SKCallExecutor

@synthesize loader = _loader;
@synthesize responseHandler = _responseHandler;
@synthesize dataConverter = _dataConverter;
@synthesize parser = _parser;
@synthesize postprocessor = _postprocessor;
@synthesize contentEncoding = _contentEncoding;

+(SKDataLoader)dataLoaderForRequest:(NSURLRequest*)request
{
    NSMutableURLRequest *realRq = [request mutableCopy];
    [realRq setHTTPShouldHandleCookies:NO];
    SKDataLoader call = ^(NSHTTPURLResponse** resp){
        NSError *callError = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:realRq
                                                                 returningResponse:resp
                                                                             error:&callError];

        if (callError)
        {
            TSKRequestException *exc = [TSKRequestException exceptionWithError:callError];
            @throw exc;
        }
        
        return data;
    };
    
    return call;
}

+(SKDataLoader)dataLoaderForLink:(NSString*)link
{
	NSURL * rqURL = [NSURL URLWithString:link];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:rqURL];
    [request addValue:@"application/json, text/json, application/xml, text/xml" forHTTPHeaderField:@"Accept"];
    [request setHTTPShouldHandleCookies:NO];
    
    return [self dataLoaderForRequest:request];
}

+(SKDataLoader)dataLoaderForLinkRoot:(NSString *)linkRoot params:(NSDictionary*)params
{
    NSString *paramStr = [params parameterString];
    NSString *link = linkRoot;
    if (paramStr)
    {
        link = [link stringByAppendingFormat:@"?%@", paramStr];
    }
    
    return [self dataLoaderForLink:link];
}

+(SKDataLoader)dataLoaderForLink:(NSString*)link postData:(NSData*)body
{
	NSURL * rqURL = [NSURL URLWithString:link];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:rqURL];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = body;
    
    return [self dataLoaderForRequest:request];
}

+(SKResponseHandler)defaultHTTPStatusHandler
{
    SKResponseHandler handler = ^(NSHTTPURLResponse* response){
        if (response.statusCode >= 400)
        {
            NSError *error = [NSError
                              errorWithDomain:NSLocalizedString(@"HTTP error", @"HTTP error")
                              code:response.statusCode userInfo:nil];
            
            TSKRequestException *exception = [TSKRequestException exceptionWithError:error];
            
            @throw exception;
        }
    };
    
    return handler;
}

+(SKDataConverter)defaultDataConverter
{
    SKDataConverter converter = ^(NSData* source, NSStringEncoding encoding){
        return [[NSString alloc] initWithData:source encoding:encoding];
    };
    
    return converter;
}

+(SKResponseParser)defaultJSONParser
{
    SKResponseParser parser = ^(NSString* str){
        return [str JSONValue];
    };
    
    return parser;
}

+(SKResponseParser)defaultXMLParser
{
    //To be implemented
    return NULL;
}

+(SKResponseProcessor)dataProcessorWithClass:(Class)proClass
{
    if (!proClass ||
        ![proClass isSubclassOfClass:[SKDataProcessor class]])
        return NULL;
    
    SKResponseProcessor processor = ^(id source){
        return [proClass dataFromStructure:source];
    };
    
    return processor;
}

+(SKCallExecutor*)defaultXMLExecutor
{
    SKCallExecutor *executor = [[self alloc] init];
    
    executor.responseHandler = [self defaultHTTPStatusHandler];
    
    executor.contentEncoding = NSUTF8StringEncoding;
    executor.dataConverter = [self defaultDataConverter];
    
    executor.parser = [self defaultXMLParser];
    
    return executor;
}

+(SKCallExecutor*)defaultJSONExecutor
{
    SKCallExecutor *executor = [[self alloc] init];
    executor.responseHandler = [self defaultHTTPStatusHandler];
    
    executor.contentEncoding = NSUTF8StringEncoding;
    executor.dataConverter = [self defaultDataConverter];
    
    executor.parser = [self defaultJSONParser];
    
    return executor;
}

-(id)execute
{
    NSHTTPURLResponse *response = nil;
    NSData *respData = self.loader(&response);
    
    if (self.responseHandler)
    {
        self.responseHandler(response);
    }
    
    NSString *dataString = self.dataConverter(respData, self.contentEncoding);
    id data = self.parser(dataString);
    
    if (self.postprocessor)
    {
        data = self.postprocessor(data);
    }
    
    return data;
}

@end
