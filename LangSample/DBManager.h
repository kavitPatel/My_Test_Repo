//
//  DBManager.h
//  LangSample
//
//  Created by Infostretch on 19/02/15.
//  Copyright (c) 2015 Infostretch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
  NSString *databasePath;
}

+ (DBManager*)getSharedInstance;
- (BOOL)createDB;
- (BOOL) saveData:(NSString*)name;
- (NSArray*) getData;

@end