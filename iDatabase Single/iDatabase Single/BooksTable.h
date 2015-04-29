//
//  BooksTable.h
//  iDatabase Single
//
//  Created by GreysTone on 4/28/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Database.h"

@interface BooksTable : NSObject {
@public int tapule_id;
@public NSString *bookName;
}


- (void) loadDatabase;
@end
