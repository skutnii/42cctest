/*
 Copyright (C) 2012 Sergii Kutnii. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

@class SKDataProcessor;

typedef NSData* (^SKDataLoader)(NSHTTPURLResponse**);
typedef void (^SKResponseHandler)(NSHTTPURLResponse*);
typedef NSString* (^SKDataConverter)(NSData*, NSStringEncoding);
typedef id (^SKResponseParser)(NSString*);
typedef id (^SKResponseProcessor)(id);

@interface SKCallExecutor : NSObject

/*
WARNING
 All the block-returning methods below copy their return values to heap.
 It's the callee's responsibility to release the results with Block_release()
 */
+(SKDataLoader)dataLoaderForRequest:(NSURLRequest*)rq;
+(SKDataLoader)dataLoaderForLink:(NSString*)link;
+(SKDataLoader)dataLoaderForLinkRoot:(NSString *)linkRoot params:(NSDictionary*)params;
+(SKDataLoader)dataLoaderForLink:(NSString*)link postData:(NSData*)body;

+(SKResponseHandler)defaultHTTPStatusHandler;

+(SKDataConverter)defaultDataConverter;

+(SKResponseParser)defaultJSONParser;
+(SKResponseParser)defaultXMLParser;

+(SKResponseProcessor)dataProcessorWithClass:(Class)proClass;

+(SKCallExecutor*)defaultXMLExecutor;
+(SKCallExecutor*)defaultJSONExecutor;

@property(nonatomic, copy) SKDataLoader loader;
@property(nonatomic, copy) SKResponseHandler responseHandler;
@property(nonatomic, copy) SKDataConverter dataConverter;
@property(nonatomic, copy) SKResponseParser parser;
@property(nonatomic, copy) SKResponseProcessor postprocessor;

@property(nonatomic, assign) NSStringEncoding contentEncoding;

-(id)execute;

@end
