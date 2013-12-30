//
//  SuggestionDataBase.h
//  Amoy Baby Care
//
//  Created by CHEN WEIBIN on 13-12-23.
//  Copyright (c) 2013年 爱摩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuggestionDataBase : NSObject

+(id)suggestionDataBase;

+(BOOL)insertSuggestionType:(int)type
                         ID:(int)typeserial
                        Url:(NSString*)url
                     Author:(NSString*)author
                  ContentCN:(NSString*)contentCN
                  ContentEN:(NSString*)contentEN;
@end
