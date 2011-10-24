#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BBWeeAppController-Protocol.h"

float VIEW_HEIGHT = 137.0f;

@interface ClockCenterController : NSObject <BBWeeAppController>
{
	UIView *_view;
    
    UILabel *timeLabel;
    
    NSTimer *clockTimer;
    
    UIImageView *hourHand;
    UIImageView *minuteHand;
    
    int hourDegrees;
    int minuteDegrees;
}

@end

#define M_PI   3.14159265358979323846264338327950288   /* pi */

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@implementation ClockCenterController

- (id)init
{
	if ((self = [super init]))
	{
		
	}
	return self;
}

- (UIView *)view
{
	if (!_view)
	{
		_view = [[UIView alloc] initWithFrame:CGRectMake(2.0f, 0.0f, 316.0f, VIEW_HEIGHT)];
        
        CGRect scrollViewRect = CGRectMake(0,0, 320, VIEW_HEIGHT);
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:scrollViewRect];
        CGSize scrollViewContentSize = CGSizeMake(640, VIEW_HEIGHT);
        [scrollView setContentSize:scrollViewContentSize];
        scrollView.pagingEnabled = YES;
        scrollView.bounces = YES;

		UIImage *bgImg = [[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/StocksWeeApp.bundle/WeeAppBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(35.0f, 4.0f, 35.0f, 4.0f)];
        UIImageView *bg = [[UIImageView alloc] initWithImage:bgImg];
        bg.frame = CGRectMake(0.0f, 0.0f, 316.0f, VIEW_HEIGHT);
        [_view addSubview:bg];
        [bg release];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 0.0f, 200.0f, VIEW_HEIGHT)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = UITextAlignmentCenter;
        timeLabel.lineBreakMode = UILineBreakModeWordWrap;
        timeLabel.numberOfLines = 2;
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.minimumFontSize = 16;
        [timeLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
        timeLabel.adjustsFontSizeToFitWidth = YES;
        [scrollView addSubview:timeLabel];
       
        UIImage *clockImg = [UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/ClockCenter.bundle/clock.png"];
        UIImageView *clock = [[UIImageView alloc] initWithImage:clockImg];
        clock.frame = CGRectMake(2.0f, 2.0f, 125.0f, 125);

        UIImage *hourImg = [UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/ClockCenter.bundle/hourHand.png"];
        hourHand = [[UIImageView alloc] initWithImage:hourImg];
        hourHand.frame = CGRectMake(0.0f, 0.0f, 5, 120);
        
        UIImage *minuteImg = [UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/ClockCenter.bundle/minuteHand.png"];
        minuteHand = [[UIImageView alloc] initWithImage:minuteImg];
        minuteHand.frame = CGRectMake(0.0f, 0.0f, 5, 120);
        
        
        [clock addSubview:hourHand];
        [clock addSubview:minuteHand];
        minuteHand.center = clock.center;
        hourHand.center = clock.center;
        
        
        [scrollView addSubview:clock];
        [_view addSubview:scrollView];
        
	}

	return _view;
}

- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration 
              curve:(int)curve degrees:(CGFloat)degrees
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}

- (void)getTime: (NSTimer *)timer{
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMMM d\nyyyy"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    NSDateFormatter *hourFormatter;
    NSString *hourString;
    
    hourFormatter = [[NSDateFormatter alloc] init];
    [hourFormatter setDateFormat:@"HH"];
    
    hourString = [hourFormatter stringFromDate:[NSDate date]];
    
    int hour = [hourString intValue];
    
    hourDegrees = hour*30;
    
    NSDateFormatter *minuteFormatter;
    NSString *minuteString;
    
    minuteFormatter = [[NSDateFormatter alloc] init];
    [minuteFormatter setDateFormat:@"mm"];
    
    minuteString = [minuteFormatter stringFromDate:[NSDate date]];

    int minute = [minuteString intValue];
    
    minuteDegrees = minute / 2;
    
    int minuteDegrees2 = minute * 6;
    
    hourDegrees = hourDegrees + minuteDegrees;
    
    [self rotateImage:hourHand duration:1 
                curve:UIViewAnimationCurveEaseIn degrees:hourDegrees];
    [self rotateImage:minuteHand duration:1 
                curve:UIViewAnimationCurveEaseIn degrees:minuteDegrees2];
    
    
    timeLabel.text = dateString;
    
    [formatter release];
    [minuteFormatter release];
    [hourFormatter release];
    
}

- (void)viewWillAppear{
   clockTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(getTime:)
                                   userInfo:nil
                                    repeats:YES];

}



- (void)viewDidDisappear{
    [clockTimer invalidate];
    clockTimer = nil;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    /*
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        CGRect rect=[self view].frame;
        rect.size.width=476;
        [self view].frame=rect;
        for(UIView* v__ in [[self view] subviews]){
            CGRect rect=v__.frame;
            rect.size.width=476;
            v__.frame=rect;
        }
    } else {
        CGRect rect=[self view].frame;
        rect.size.width=316;
        [self view].frame=rect;
        for(UIView* v__ in [[self view] subviews]){
            CGRect rect=v__.frame;
            rect.size.width=316;
            v__.frame=rect;
        }
    }
    */
}

- (float)viewHeight
{
	return VIEW_HEIGHT;
}

@end
