//
//  AFRaptureXMLRequestOperation.m
//
//  Created by Jan Sanchez on 5/13/12.
//  Copyright (c) 2012 Jan Sanchez. All rights reserved.
//

#import "AFRaptureXMLRequestOperation.h"

static dispatch_queue_t af_rapture_xml_request_operation_processing_queue;
static dispatch_queue_t rapture_xml_request_operation_processing_queue() {
    if (af_rapture_xml_request_operation_processing_queue == NULL) {
        af_rapture_xml_request_operation_processing_queue = dispatch_queue_create("net.jansanchez.xml-request.processing", 0);
    }
    
    return af_rapture_xml_request_operation_processing_queue;
}

@interface AFRaptureXMLRequestOperation ()
@property (readwrite, nonatomic, retain) RXMLElement *responseXMLElement;
@property (readwrite, nonatomic, retain) NSError *XMLError;
@end

@implementation AFRaptureXMLRequestOperation

@synthesize responseXMLElement = _responseXMLElement;
@synthesize XMLError = _XMLError;

+ (AFRaptureXMLRequestOperation *)XMLParserRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement))success
                                                        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement))failure
{
    AFRaptureXMLRequestOperation *requestOperation = [[[self alloc] initWithRequest:urlRequest] autorelease];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation.request, operation.response, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error, [(AFRaptureXMLRequestOperation *)operation responseXMLElement]);
        }
    }];
    
    return requestOperation;
}

- (void)dealloc {
    [_responseXMLElement release];    
    [_XMLError release];    
    [super dealloc];
}

- (RXMLElement *)responseXMLElement {
    if (!_responseXMLElement && [self.responseData length] > 0 && [self isFinished]) {
        self.responseXMLElement = [RXMLElement elementFromXMLData:self.responseData];
    }
    
    return _responseXMLElement;
}

- (NSError *)error {
    if (_XMLError) {
        return _XMLError;
    } else {
        return [super error];
    }
}

#pragma mark - NSOperation

- (void)cancel {
    [super cancel];
    
//    self.responseXMLParser.delegate = nil;
}

#pragma mark - AFHTTPRequestOperation

+ (NSSet *)acceptableContentTypes {
    return [NSSet setWithObjects:@"application/xml", @"text/xml", nil];
}

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    return [[[request URL] pathExtension] isEqualToString:@"xml"] || [super canProcessRequest:request];
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    self.completionBlock = ^ {
        if ([self isCancelled]) {
            return;
        }
        
        dispatch_async(rapture_xml_request_operation_processing_queue(), ^(void) {
            RXMLElement *XMLElement = self.responseXMLElement;
            
            if (self.error) {
                if (failure) {
                    dispatch_async(self.failureCallbackQueue ? self.failureCallbackQueue : dispatch_get_main_queue(), ^{
                        failure(self, self.error);
                    });
                }
            } else {
                if (success) {
                    dispatch_async(self.successCallbackQueue ? self.successCallbackQueue : dispatch_get_main_queue(), ^{
                        success(self, XMLElement);
                    });
                } 
            }
        });
    };    
}

@end
