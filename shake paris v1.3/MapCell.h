//
//  mapCell.h
//  shake paris v1.3
//
//  Created by user on 29/05/13.
//  Copyright (c) 2013 com.bowenstudio.*. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Restaurant.h"

typedef enum {
    ButtonType_Profile = 0,
    ButtonType_Distance,
    ButtonType_More,

}ButtonType;

typedef void (^ClickButtonBlock)(ButtonType aType);

@class PlaceDetailVO;
@interface MapCell : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBg;
@property (weak, nonatomic) IBOutlet UIButton *buttonItem1;
@property (weak, nonatomic) IBOutlet UIButton *buttonItem2;
@property (weak, nonatomic) IBOutlet UIButton *buttonItem3;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@property (nonatomic,strong)PlaceDetailVO   *placeDetailVO;
@property (nonatomic,strong)Restaurant *restaurant;

@property (nonatomic,strong)ClickButtonBlock    blockButton;

+(MapCell*)getInstanceWithNibWithBlock:(ClickButtonBlock)aBlock;
-(void)toAppearItemsView;

@end
