//
//  ViewController.m
//  Business Time
//
//  Created by Randall Dailey on 10/21/15.
//  Copyright © 2015 Randall Dailey. All rights reserved.
//

#import "ViewController.h"
#import "Localytics.h"

@interface ViewController () <UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {

    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://biztime2.s3-website-us-east-1.amazonaws.com/"]];
    [self.webView loadRequest:request];
}

#pragma - mark UIWebView Delegate Methods
- (BOOL)webView:(nonnull UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSURL *url = request.URL;
    
    if (![url.scheme isEqualToString:@"localytics"]) {
        return YES;
    }
    
    if ([url.host caseInsensitiveCompare:@"event"] == NSOrderedSame) {
        NSString *event = [self valueFromQueryStringKey:@"event" url:url];
        if (event) {
            NSString *attributes = [self valueFromQueryStringKey:@"attributes" url:url];
            NSMutableDictionary* attributesDict = nil;
            if(attributes) {
                NSData *attributesData = [attributes dataUsingEncoding:NSUTF8StringEncoding];
                attributesDict = [[self dictFromJSON:attributesData] mutableCopy];
            }
        
            [Localytics tagEvent:event attributes:attributesDict];
        }
    }
    else if ([url.host caseInsensitiveCompare:@"profile"] == NSOrderedSame) {
        NSString *key = [self valueFromQueryStringKey:@"key" url:url];
        NSString *value = [self valueFromQueryStringKey:@"value" url:url];
        
        if (key && value) {
            [Localytics setValue:value forProfileAttribute:key withScope:LLProfileScopeOrganization];
        }
    }


    return NO;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Failed to load with error :%@",[error debugDescription]);
    
}


- (NSString *)valueFromQueryStringKey:(NSString *)queryStringKey url:(NSURL *)url
{
    if (!queryStringKey.length || !url.query)
        return nil;
    
    NSArray *urlComponents = [url.query componentsSeparatedByString:@"&"];
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *keyValuePairComponents = [keyValuePair componentsSeparatedByString:@"="];
        if ([[keyValuePairComponents objectAtIndex:0] isEqualToString:queryStringKey])
        {
            if(keyValuePairComponents.count == 2)
                return [[keyValuePairComponents objectAtIndex:1]
                        stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return nil;
}


- (NSDictionary *)dictFromJSON:(NSData *)jsonData
{
    id results = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    if (results && [results isKindOfClass:[NSDictionary class]]){
        return results;
    }
    
    return nil;
}



@end
