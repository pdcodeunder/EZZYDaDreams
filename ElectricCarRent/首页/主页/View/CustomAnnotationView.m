//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"

#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  55.0

@interface CustomAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIButton *mallPromsBtn;
@property (nonatomic, strong) UIImageView *backImgView;

@end

@implementation CustomAnnotationView

@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;

#pragma mark - Handle Action
#pragma mark - Override

- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    if (self.sigleCount == 100) {
        return;
    }
    if (selected && self.carDataModel) {
        if (self.annotationCount > 1) {
            self.salceMapView(self.coordinate);
        } else {
            if (self.bookCarBlock) {
                self.bookCarBlock(self.carDataModel);
            }
        }
    }
    [super setSelected:selected animated:animated];
}

#pragma mark - Life Cycle
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.manager = [ECarMapManager new];
        
        self.bounds = CGRectMake(0.f, 0.f, 50, 50);
        self.backgroundColor = [UIColor clearColor];
        
        if (/* DISABLES CODE */ (1)) {
            self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 48, 48)];
            [self addSubview:self.portraitImageView];
        }else{
            self.backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_mark.png"]];
            [_backImgView setFrame:CGRectMake(kHoriMargin-5, kVertMargin-5, 40, 40)];
            [self addSubview:_backImgView];
            
            self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
            [_backImgView addSubview:self.portraitImageView];
        }
        
        /* Create name label. */
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitWidth + kHoriMargin,
                                                                   kVertMargin,
                                                                   kWidth - kPortraitWidth - kHoriMargin,
                                                                   kHeight - 2 * kVertMargin)];
        self.nameLabel.backgroundColor  = [UIColor clearColor];
        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
        self.nameLabel.textColor        = [UIColor whiteColor];
        self.nameLabel.font             = FontType;
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)setAnnotationCount:(NSInteger)annotationCount
{
    if (self.carDataModel == nil) {
        return;
    }
    _annotationCount = annotationCount;
    if (annotationCount > 20) {
        self.image = [UIImage imageNamed:@"cheweizhi21"];
    } else {
        self.image = [UIImage imageNamed:[NSString stringWithFormat:@"cheweizhi%zd", annotationCount]];
    }
}

@end
