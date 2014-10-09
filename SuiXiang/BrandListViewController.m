//
//  HomeViewController.m
//  novel-design
//
//  Created by ltebean on 14-8-26.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "BrandListViewController.h"
#import "BrandCell.h"
#import "LTSharedViewTransition.h"
#import "POP.h"

@interface BrandListViewController ()<UITableViewDataSource,UITableViewDelegate,LTSharedViewTransitionDataSource,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *brandList;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property BOOL animated;
@end

@implementation BrandListViewController

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    return [[LTSharedViewTransition alloc] init];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate=self;
    self.tableView.dataSource=self;

}

-(UIView*) sharedView
{
    BrandCell *cell =(BrandCell*) [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    return cell.brandTitleLabel;
}

-(void) viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [self.tableView reloadData];
    if(!self.animated){
        [self animateTableView];
        self.animated=YES;
    }
    self.navigationController.delegate = self;

}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

-(void) animateTableView
{
    self.tableView.alpha = 0.0f;
    
    CGFloat diff = .05;
    CGFloat tableHeight = self.tableView.bounds.size.height;
    NSArray *cells = [self.tableView visibleCells];
    
    // Iterate across the rows and translate them down off the screen
    for (NSUInteger i = 0; i < [cells count]; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        cell.transform = CGAffineTransformMakeTranslation(320, 0);
    }
    
    // Now that all rows are off the screen, make the tableview opaque again
    self.tableView.alpha = 1.0f;
    
    // Animate each row back into place
    for (NSUInteger i = 0; i < [cells count]; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        
        [UIView animateWithDuration:1.1 delay:diff*i usingSpringWithDamping:0.77
              initialSpringVelocity:0 options:0 animations:^{
                  cell.transform = CGAffineTransformMakeTranslation(0, 0);
              } completion:NULL];
    }
}

#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Brand";
    BrandCell *cell = (BrandCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    int index= [self randomNumberBetween:1 to:4];
    NSString *logo=[NSString stringWithFormat:@"logo%d.png",index];
    //[cell.imageView setImage:[UIImage imageNamed:logo]];
    return cell;
}

-(int)randomNumberBetween:(int)from to:(int)to
{
    
    return (int)from + arc4random() % (to-from+1);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath=indexPath;
    [self performSegueWithIdentifier:@"brandDetail" sender:nil];
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
