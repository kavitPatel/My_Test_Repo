//
//  DBManager.m
//  LangSample
//
//  Created by Infostretch on 19/02/15.
//  Copyright (c) 2015 Infostretch. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
  if (!sharedInstance) {
    sharedInstance = [[super allocWithZone:NULL]init];
    [sharedInstance createDB];
  }
  return sharedInstance;
}

-(BOOL)createDB{

  // Get the documents directory
  NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *docsDir = dirPaths[0];
  // Build the path to the database file
  databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent: @"student.db"]];
  BOOL isSuccess = YES;
  NSFileManager *filemgr = [NSFileManager defaultManager];
  if ([filemgr fileExistsAtPath: databasePath ] == NO)
  {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
      char *errMsg;
      const char *sql_stmt = "create table if not exists studentsDetail (name text)";
      if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
      {
        isSuccess = NO;
        NSLog(@"Failed to create table");
      }
      sqlite3_close(database);
      return  isSuccess;
    }
    else {
      isSuccess = NO;
      NSLog(@"Failed to open/create database");
    }
  }
  return isSuccess;
}

- (BOOL) saveData:(NSString*)name
{
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *insertSQL = [NSString stringWithFormat:@"insert into studentsDetail (name) values (\"%@\")",name];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    
    sqlite3_reset(statement);
  }
  return NO;
}
                            
- (NSArray*) getData
{
      const char *dbpath = [databasePath UTF8String];
      if (sqlite3_open(dbpath, &database) == SQLITE_OK)
      {
        //NSString *querySQL = [NSString stringWithFormat:@"select name, department, year from studentsDetail where regno=\"%@\"",registerNumber];
        NSString *querySQL = @"select name from studentsDetail";
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
          while(sqlite3_step(statement) == SQLITE_ROW)
          {
            NSString *name = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 0)];
            [resultArray addObject:name];
          }
          
          sqlite3_reset(statement);
          return resultArray;
        }
      }
      return nil;
}
@end
