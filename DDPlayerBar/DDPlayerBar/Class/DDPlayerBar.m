//
//  DDPlayerBar.m
//  DDPlayerBar
//
//  Created by lovelydd on 15/11/27.
//  Copyright © 2015年 xiaomutou. All rights reserved.
//

#import "DDPlayerBar.h"

typedef NS_ENUM(NSUInteger, DDPlayState) {
  DDPlayStatePlay,
  DDPlayStatePause,
  DDPlayStateDarge,
};

@interface DDPlayButton : UIButton

@property(nonatomic, assign) DDPlayState playState;
@end

@implementation DDPlayButton

- (instancetype)initWithFrame:(CGRect)frame {

  self = [super initWithFrame:frame];
  if (self) {

    [self commonInit];
  }

  return self;
}

- (void)commonInit {

  self.adjustsImageWhenHighlighted = NO;

  [self setBackgroundImage:[UIImage imageNamed:@"PlayerButtonBackground"]
                  forState:UIControlStateNormal];
  [self setBackgroundImage:[UIImage imageNamed:@"PlayerButtonBackgroundPressed"]
                  forState:UIControlStateHighlighted];
  [self setBackgroundImage:[UIImage imageNamed:@"PlayerButtonBackgroundPressed"]
                  forState:UIControlStateSelected | UIControlStateHighlighted];

  [self setImage:[UIImage imageNamed:@"PlayerPlay"]
        forState:UIControlStateNormal];
  [self setImage:[UIImage imageNamed:@"PlayerPause"]
        forState:UIControlStateSelected];

  [self addTarget:self
                action:@selector(updateState)
      forControlEvents:UIControlEventTouchUpInside];
}

- (void)sizeToFit {
  CGRect frame = self.frame;
  frame.size = [self backgroundImageForState:UIControlStateNormal].size;
  self.frame = frame;
}

#pragma mark - Event
- (void)updateState {

  if (self.playState != DDPlayStateDarge) {
    self.selected = !self.selected;
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];

  self.playState = DDPlayStateDarge;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

  [super touchesEnded:touches withEvent:event];
  self.playState = self.isSelected;
}

- (void)setPlayState:(DDPlayState)playState {

  _playState = playState;
  switch (playState) {
  case DDPlayStatePlay: {

    NSLog(@"DDPlayStatePlay");
    self.selected = NO;
    [self setImage:[self imageForState:UIControlStateNormal]
          forState:UIControlStateHighlighted];
    break;
  }
  case DDPlayStatePause: {
    NSLog(@"DDPlayStatePause");
    self.selected = YES;
    [self setImage:[self imageForState:UIControlStateSelected]
          forState:UIControlStateSelected | UIControlStateHighlighted];
    break;
  }
  case DDPlayStateDarge: {
    NSLog(@"DDPlayStateDarge");
    [self setImage:[UIImage imageNamed:@"PlayerDrag"]
          forState:self.state | UIControlStateHighlighted];
    break;
  }
  default: { break; }
  }
}
@end

@interface DDPlayerBar ()

@property(nonatomic, assign) CGRect lastFrame;

@property(nonatomic, weak) UIView *backgroundView;
@property(nonatomic, weak) UIView *currentView;

@property(nonatomic, weak) DDPlayButton *playButton;
@end
@implementation DDPlayerBar

- (instancetype)initWithFrame:(CGRect)frame {

  self = [super initWithFrame:frame];
  if (self) {

    UIImage *playerBackground = [UIImage imageNamed:@"PlayerBackground"];
    playerBackground = [playerBackground
        stretchableImageWithLeftCapWidth:playerBackground.size.width / 2
                            topCapHeight:playerBackground.size.height / 2];
    UIImageView *backgroundView =
        [[UIImageView alloc] initWithImage:playerBackground];
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;

    UIImage *playerCurrent = [UIImage imageNamed:@"PlayerCurrent"];
    playerCurrent = [playerCurrent
        stretchableImageWithLeftCapWidth:playerCurrent.size.width / 2
                            topCapHeight:playerCurrent.size.height / 2];
    UIImageView *currentView =
        [[UIImageView alloc] initWithImage:playerCurrent];
    [self addSubview:currentView];
    self.currentView = currentView;

    DDPlayButton *playButton = [[DDPlayButton alloc] init];
    [playButton addTarget:self
                   action:@selector(buttonDrag:withEvent:)
         forControlEvents:UIControlEventTouchDragInside];
    [self addSubview:playButton];
    self.playButton = playButton;
  }

  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  if (CGRectEqualToRect(self.lastFrame, self.frame)) {
    return;
  }

  self.lastFrame = self.frame;

  self.backgroundView.frame =
      CGRectMake(17, (CGRectGetHeight(self.bounds) -
                      CGRectGetHeight(self.backgroundView.bounds)) /
                         2,
                 CGRectGetWidth(self.bounds) - 17 * 2,
                 CGRectGetHeight(self.backgroundView.bounds));
  [self.playButton sizeToFit];
  self.playButton.frame = CGRectMake(
      0,
      (CGRectGetHeight(self.bounds) - CGRectGetHeight(self.playButton.bounds)) /
          2,
      CGRectGetWidth(self.playButton.bounds),
      CGRectGetHeight(self.playButton.bounds));
  [self updateCurrentView];
}

- (void)buttonDrag:(UIButton *)button withEvent:(UIEvent *)event {

  UITouch *touch = [[event touchesForView:button] anyObject];
  CGPoint point = [touch locationInView:self];
  CGPoint lastPoint = [touch previousLocationInView:self];

  button.center = CGPointMake(
      MIN(CGRectGetWidth(self.bounds) - CGRectGetWidth(button.bounds) / 2,
          MAX(CGRectGetWidth(button.bounds) / 2,
              button.center.x + (point.x - lastPoint.x))),
      button.center.y);

  [self updateCurrentView];
}

- (void)updateCurrentView {

  CGRect currentViewFrame = CGRectMake(
      self.backgroundView.frame.origin.x, self.backgroundView.frame.origin.y,
      CGRectGetMaxX(self.playButton.frame) -
          CGRectGetMinX(self.backgroundView.frame) * 2,
      self.backgroundView.bounds.size.height);
  self.currentView.frame = currentViewFrame;
}
@end
