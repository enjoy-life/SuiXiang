//
//  BrandDetailViewController.m
//  SuiXiang
//
//  Created by ltebean on 14-10-9.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "BrandDetailViewController.h"
#import "LTSharedViewTransition.h"
#import "LTParallaxScrollView.h"
#import "BrandListViewController.h"
#import "POP.h"

@interface BrandDetailViewController ()<LTSharedViewTransitionDataSource,UIScrollViewDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *topView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet LTParallaxScrollView *parallaxView;
@property (weak, nonatomic) IBOutlet UILabel *brandTitleLabel;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@end

@implementation BrandDetailViewController



-(UIView*) sharedView
{
    return self.brandTitleLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.parallaxView.delegate=self;
    
    UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
    popRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:popRecognizer];

}

- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
    // Calculate how far the user has dragged across the view
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // Create a interactive transition and pop the view controller
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Update the interactive transition's progress
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        if (progress > 0.5) {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (fromVC == self && [toVC isKindOfClass:[BrandListViewController class]]) {
        return [[LTSharedViewTransition alloc] init];
    }
    else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    // Check if this is for our custom transition
    if ([animationController isKindOfClass:[LTSharedViewTransition class]]) {
        return self.interactivePopTransition;
    }
    else {
        return nil;
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    [self animateMainView];
    
}

-(void) animateMainView
{
    self.contentView.transform = CGAffineTransformMakeTranslation(0, 320);
    [UIView animateWithDuration:0.8 delay:0.2 usingSpringWithDamping:0.8
          initialSpringVelocity:0 options:0 animations:^{
              self.contentView.transform = CGAffineTransformIdentity;
          } completion:NULL];
    
//    POPSpringAnimation *animation = [self.contentView.layer pop_animationForKey:@"positionTranslation"];
//    animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
//    animation.fromValue = @600;
//    animation.toValue = @0;
//    animation.springBounciness = 8.0f;
//    animation.springSpeed = 5.0f;
//    [self.contentView.layer pop_addAnimation:animation forKey:@"positionTranslation"];

}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

-(void)viewDidLayoutSubviews
{
    self.parallaxView.contentSize=CGSizeMake(320, 1000);
    [self.parallaxView setAcceleration:CGPointMake(1, 0.5) forView:self.topView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < 0) {
        [self.parallaxView setZoomSpeed:CGPointMake(0.7, 0.7) forView:self.topView];
    }else{
        [self.parallaxView setZoomSpeed:CGPointMake(0, 0) forView:self.topView];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
