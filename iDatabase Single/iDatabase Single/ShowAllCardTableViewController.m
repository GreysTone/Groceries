//
//  ShowAllCardTableViewController.m
//  iDatabase Single
//
//  Created by GreysTone on 4/28/15.
//  Copyright (c) 2015 GreysTone. All rights reserved.
//

#import "ShowAllCardTableViewController.h"

extern Database *gtDatabase;

@interface ShowAllCardTableViewController ()

@end

@implementation ShowAllCardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.booksTable = [[NSMutableArray alloc] init];
    NSString *sql;
    
    sql = @"SELECT * FROM Card";
    NSLog(@"%@", sql);
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(gtDatabase->dbPtr, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        NSLog(@"[SUCC] Select Data");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            BooksTable *bTable = [[BooksTable alloc] init];
            int dbId = sqlite3_column_int(statement, 0);
            int dbcId = sqlite3_column_int(statement, 1);
            NSString *dbName = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
            NSString *dbUnit = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
            int dbCate = sqlite3_column_int(statement, 4);
            NSString *listName = @"[";
            listName = [listName stringByAppendingFormat:@"%d:%d", dbcId, dbCate];
            listName = [listName stringByAppendingString:@"] "];
            listName = [listName stringByAppendingString:dbName];
            listName = [listName stringByAppendingString:@" <"];
            listName = [listName stringByAppendingString:dbUnit];
            listName = [listName stringByAppendingString:@">"];
            
            bTable->tapule_id = dbId;
            bTable->bookName = listName;
            NSLog(@"%@", bTable->bookName);
            [self.booksTable addObject:bTable];
            //NSLog(@"%ld", [self.booksTable count]);
        }
    }
    else {
        NSLog(@"[FAIL] Select Error");
    }
    sqlite3_finalize(statement);

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.booksTable count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCardPrototype" forIndexPath:indexPath];
    
    // Configure the cell...
    BooksTable *bookItem = [self.booksTable objectAtIndex:indexPath.row];
    NSLog(@"%@", bookItem->bookName);
    cell.textLabel.text = bookItem->bookName;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSString *delete = @"DELETE FROM Card WHERE id = ";
        BooksTable *bookCurItem = [self.booksTable objectAtIndex:indexPath.row];
        delete = [delete stringByAppendingFormat:@"%d",bookCurItem->tapule_id];
        
        char *errMsg;
        if(sqlite3_exec(gtDatabase->dbPtr, [delete UTF8String], NULL, NULL, &errMsg) == SQLITE_OK) {
            NSLog(@"[SUCC] Delete From Card");
            [self.booksTable removeObjectAtIndex:indexPath.row];
        }
        else {
            NSLog(@"[FAIL] Delete From Card");
            NSLog(@"%s", errMsg);
        }
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
