//
//  HTTPGetRequestMessage.h
//  InnerBand
//
//  InnerBand - The iOS Booster!
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>
#import "DispatchMessage.h"
#import "Types.h"

/*
 * 
 * MessageCenter will dispatch an HTTPGetRequestMessage after it processes the URL request you provide it.
 * When specifying a URL, you can provide substitution parameters using the syntax [MYPARAM] and
 * then providing the values for those parameters in the userInfo dictionary.
 *
 * INPUT: none
 * OUTPUT: the HTTP response data on success, nil on error
 *
 * USER INFO:
 *    HTTP_STATUS_CODE - HTTP status code of result
 *
 */

#define HTTP_STATUS_CODE @"HTTP_STATUS_CODE"

@interface HTTPGetRequestMessage : DispatchMessage {
	NSString *_url;
	NSMutableData *_responseData;
	NSMutableDictionary *_headersDict;
    ib_http_proc_t _processBlock;
}

+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url;
+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url processBlock:(ib_http_proc_t)processBlock;

- (void)addHeaderValue:(NSString *)value forKey:(NSString *)key;

@end
