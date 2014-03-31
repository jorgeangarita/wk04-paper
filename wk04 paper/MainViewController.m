//
//  MainViewController.m
//  wk04 paper
//
//  Created by Jorge Angarita on 3/30/14.
//  Copyright (c) 2014 jorge. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headlineView;
@property (weak, nonatomic) IBOutlet UIImageView *feedView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *menuView;

@property (nonatomic, assign) float startPointY;

- (void)onPanHeadline:(UIPanGestureRecognizer *)panGestureRecognizerHeadline;
- (void)onTapHeadline:(UITapGestureRecognizer *)tapGestureRecognizerHeadline;
- (void)onPanFeed:(UIPanGestureRecognizer *)panGestureRecognizerFeed;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.headlineView.layer.cornerRadius = 15;
    self.mainView.layer.cornerRadius = 15;
    
    
    self.headlineView.userInteractionEnabled = YES;
    self.feedView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizerHeadline = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapHeadline:)];
    [self.headlineView addGestureRecognizer:tapGestureRecognizerHeadline];
    
    
    UIPanGestureRecognizer *panGestureRecognizerHeadline = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanHeadline:)];
    [self.headlineView addGestureRecognizer:panGestureRecognizerHeadline];
    
    
    UIPanGestureRecognizer *panGestureRecognizerFeed = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanFeed:)];
    [self.feedView addGestureRecognizer:panGestureRecognizerFeed];
    
    self.menuView.alpha = 0.2;
    CGAffineTransform transform = CGAffineTransformMakeScale(0.975, 0.975);
    self.menuView.transform = transform;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)onPanHeadline:(UIPanGestureRecognizer *)panGestureRecognizerHeadline {
    //NSLog(@"headline pan started");
    //CGPoint point = [panGestureRecognizerHeadline locationInView:self.view];
    CGPoint velocity = [panGestureRecognizerHeadline velocityInView:self.view];
    CGPoint translation = [panGestureRecognizerHeadline translationInView:self.view];
    
    
    if (self.mainView.frame.origin.y > -1) {
    self.mainView.frame = CGRectMake(self.mainView.frame.origin.x, self.mainView.frame.origin.y + translation.y, self.mainView.frame.size.width, self.mainView.frame.size.height);
    [panGestureRecognizerHeadline setTranslation:CGPointMake(0, 0) inView:panGestureRecognizerHeadline.view];
    }
    
    else if (velocity.y < 0 && self.mainView.frame.origin.y < 0) {
        NSLog(@"resistance started");
        self.mainView.frame = CGRectMake(self.mainView.frame.origin.x, self.mainView.frame.origin.y + translation.y/5, self.mainView.frame.size.width, self.mainView.frame.size.height);
        [panGestureRecognizerHeadline setTranslation:CGPointMake(0, 0) inView:panGestureRecognizerHeadline.view];
        
    }
    else if (velocity.y > 0 && self.mainView.frame.origin.y < 0) {
        NSLog(@"resistance down");
        self.mainView.frame = CGRectMake(self.mainView.frame.origin.x, self.mainView.frame.origin.y + translation.y, self.mainView.frame.size.width, self.mainView.frame.size.height);
        [panGestureRecognizerHeadline setTranslation:CGPointMake(0, 0) inView:panGestureRecognizerHeadline.view];
        
    }


    
    if (panGestureRecognizerHeadline.state == UIGestureRecognizerStateEnded){
        if (velocity.y > 0) {
            [UIView animateWithDuration:1
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0.5
                                options:UIViewAnimationOptionAllowAnimatedContent | 2 << 16
                             animations:^{
                                 self.mainView.frame = CGRectMake(self.mainView.frame.origin.x, 520, self.mainView.frame.size.width, self.mainView.frame.size.height);
                                 
                                 self.menuView.alpha = 1;
                                 CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
                                 self.menuView.transform = transform;
                                 
                             } completion:nil];
            
        } else if (velocity.y < 0){
            [UIView animateWithDuration:0.75
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:0.5
                                options:UIViewAnimationOptionAllowAnimatedContent | 2 << 16
                             animations:^{
                                 self.mainView.frame = CGRectMake(self.mainView.frame.origin.x, 0, self.mainView.frame.size.width, self.mainView.frame.size.height);
                                 
                                 self.menuView.alpha = 0.2;
                                 CGAffineTransform transform = CGAffineTransformMakeScale(0.975, 0.975);
                                 self.menuView.transform = transform;
                                 
                             } completion:nil];
        }
    }
    
    if (self.mainView.frame.origin.y > 0) {
        float varAlpha = self.mainView.frame.origin.y/520*0.8;
        float varScale = self.mainView.frame.origin.y/520*0.025;
        
        self.menuView.alpha = 0.4 + varAlpha;
        NSLog(@"varAlpha: %f", varAlpha);
        
        CGAffineTransform transform = CGAffineTransformMakeScale(0.975 + varScale, 0.975 + varScale);
        self.menuView.transform = transform;
        
    }
}

- (void)onPanFeed:(UIPanGestureRecognizer *)panGestureRecognizerFeed {
    CGPoint velocity = [panGestureRecognizerFeed velocityInView:self.view];
    CGPoint translation = [panGestureRecognizerFeed translationInView:self.view];
    self.feedView.frame = CGRectMake(self.feedView.frame.origin.x + translation.x, self.feedView.frame.origin.y, self.feedView.frame.size.width, self.feedView.frame.size.height);
    [panGestureRecognizerFeed setTranslation:CGPointMake(0, 0) inView:panGestureRecognizerFeed.view];
    
    

    
    if (panGestureRecognizerFeed.state == UIGestureRecognizerStateEnded) {
        if (self.feedView.frame.origin.x > 0){
            [UIView animateWithDuration:1
                                  delay:0
                 usingSpringWithDamping:0.9
                  initialSpringVelocity:0.5
                                options:UIViewAnimationOptionAllowAnimatedContent | 2 << 16
                             animations:^{
                                 self.feedView.frame = CGRectMake(0, self.feedView.frame.origin.y, self.feedView.frame.size.width, self.feedView.frame.size.height);
                             } completion:nil];
        } else if (self.feedView.frame.origin.x < -1124){
            [UIView animateWithDuration:1
                                  delay:0
                 usingSpringWithDamping:0.9
                  initialSpringVelocity:0.5
                                options:UIViewAnimationOptionAllowAnimatedContent | 2 << 16
                             animations:^{
                                 self.feedView.frame = CGRectMake(-1124, self.feedView.frame.origin.y, self.feedView.frame.size.width, self.feedView.frame.size.height);
                             } completion:nil];
        }
        
        else if (velocity.x > 0) {
            [UIView animateWithDuration:0.75
                                  delay:0
                 usingSpringWithDamping:1
                  initialSpringVelocity:1
                                options:UIViewAnimationOptionAllowAnimatedContent | 1 << 16
                             animations:^{
                                 self.feedView.frame = CGRectMake(self.feedView.frame.origin.x + 100, self.feedView.frame.origin.y, self.feedView.frame.size.width, self.feedView.frame.size.height);
                             } completion:nil];
        } else if (velocity.x < 0){
            [UIView animateWithDuration:0.75
                                  delay:0
                 usingSpringWithDamping:1
                  initialSpringVelocity:1
                                options:UIViewAnimationOptionAllowAnimatedContent | 1 << 16
                             animations:^{
                                 self.feedView.frame = CGRectMake(self.feedView.frame.origin.x - 100, self.feedView.frame.origin.y, self.feedView.frame.size.width, self.feedView.frame.size.height);
                             } completion:nil];
        }
    }
    
}
- (void)onTapHeadline:(UITapGestureRecognizer *)tapGestureRecognizerHeadline {
    NSLog(@"headline tap");
    
    if (self.mainView.frame.origin.y == 520){
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:1
                            options:UIViewAnimationOptionAllowAnimatedContent | 2 << 16
                         animations:^{
                             self.mainView.frame = CGRectMake(self.mainView.frame.origin.x, 0, self.mainView.frame.size.width, self.mainView.frame.size.height);
                             
                             self.menuView.alpha = 0.6;
                             CGAffineTransform transform = CGAffineTransformMakeScale(0.975, 0.975);
                             self.menuView.transform = transform;
                             
                         } completion:nil];
    }

    
}
@end
