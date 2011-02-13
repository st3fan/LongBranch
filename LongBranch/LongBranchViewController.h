// LongBranchViewController.h

#import <UIKit/UIKit.h>
#import "PredictionRequest.h"

@interface LongBranchViewController : UIViewController <PredictionRequestDelegate> {
  @private
    UILabel* _toHhomeStatusLabel;
    UILabel* _toOfficeStatusLabel;
  @private
    PredictionRequest* _homePredictionRequest;
    PredictionRequest* _officePredictionRequest;
    PredictionRequest* _humberLoopPredictionRequest;
	NSArray* _officePredictions;
	NSArray* _humberLoopPredictions;
}

@property (nonatomic,assign) IBOutlet UILabel* toHomeStatusLabel;
@property (nonatomic,assign) IBOutlet UILabel* toOfficeStatusLabel;

@end
