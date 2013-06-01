//
//  JSViewController.m
//  RaptureXMLOperationExample
//
//  Created by Jan Sanchez on 6/1/13.
//  Copyright (c) 2013 Jan Sanchez. All rights reserved.
//

#import "JSViewController.h"
#import <AFRaptureXMLRequestOperation/AFRaptureXMLRequestOperation.h>
#import <RaptureXML/RXMLElement.h>

@interface JSViewController ()

@property (nonatomic, strong) NSArray *items;

- (NSArray *)parseXMLElement:(RXMLElement *)XMLElement;

@end

@implementation JSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _items = @[@"Loading.."];
    
    NSURL *testURL = [NSURL URLWithString:@"http://musicbrainz.org/ws/2/release?artist=cc197bad-dc9c-440d-a5b5-d52ba2e14234&status=official&type=album"];
    
    AFRaptureXMLRequestOperation *operation = [AFRaptureXMLRequestOperation XMLParserRequestOperationWithRequest:[NSURLRequest requestWithURL:testURL] success:^(NSURLRequest *request, NSHTTPURLResponse *response, RXMLElement *XMLElement) {
        // Do something with XMLElement
        self.items = [self parseXMLElement:XMLElement];
        [self.tableView reloadData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, RXMLElement *XMLElement) {
        // Handle Error
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
    
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)parseXMLElement:(RXMLElement *)XMLElement
{
    RXMLElement *releaseListXMLELement = [XMLElement child:@"release-list"];
    NSArray *albums = [releaseListXMLELement children:@"release"];
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[albums count]];
    
    for (RXMLElement *album in albums) {
        NSString *title = [album child:@"title"].text;
        [items addObject:title];
    }
    return [items copy];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSString *item = _items[indexPath.row];
    cell.textLabel.text = item;
    
    return cell;
}

@end
