//
//  BoolList.h
//  Compiler
//
//  Created by Duan Dajun on 12/6/10.
//  Copyright 2010 SJTU. All rights reserved.
//


@interface BoolList : NSObject 
{
	BOOL head;
  BoolList *tail;
}
@property (readwrite) BOOL head;
@property (readwrite, retain) BoolList *tail;
- (id)initWithBool:(BOOL)aBool;
- (id)initWithBool:(BOOL)aBool boolList:(BoolList *)aBoolList;
+ (id)boolListWithBool:(BOOL)aBool;
+ (id)boolListWithBool:(BOOL)aBool boolList:(BoolList *)aBoolList;
@end
