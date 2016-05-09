


#import "ECarBaseViewController.h"
#import "AMapSearchManager.h"

typedef void(^bookCarback)(AMapPOI *poi);
typedef void (^DestinationBlock)(AMapPOI *poi);

@interface ECarInputViewController : ECarBaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *fuzzySearchTable;
@property (copy, nonatomic) DestinationBlock destinationBlock;
@property (strong ,nonatomic) AMapPOI * currentPOI;
@property (copy, nonatomic) bookCarback bookbackCar;
@property (strong, nonatomic)UIView * bgView;
@property (strong, nonatomic)UIButton * homeButton;
@property (strong, nonatomic)UIButton * workButton;
@property (strong, nonatomic)UIButton * yongLiButton;

@end
