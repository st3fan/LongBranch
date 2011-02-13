// LongBranchViewController.m

#import "ASIHTTPRequest.h"
#import "Prediction.h"
#import "PredictionRequest.h"
#import "LongBranchViewController.h"

#define kAgency		@"ttc"
#define kRoute		@"501"

#define kHomeStop		@"lake5th_e"
#define kOfficeStop		@"queespad_w"
#define kHumberLoopStop	@"humbquee_w_a"

@implementation LongBranchViewController

@synthesize toHomeStatusLabel = _toHomeStatusLabel;
@synthesize toOfficeStatusLabel = _toOfficeStatusLabel;

- (void) predictionRequest: (PredictionRequest*) predictionRequest didFailWithError: (NSError*) error
{
	if (predictionRequest == _homePredictionRequest) {
		_toHomeStatusLabel.text = @"Fail";
		return;
	}

	if (predictionRequest == _officePredictionRequest) {
		_toOfficeStatusLabel.text = @"Fail";
		return;
	}
}

- (NSString*) formatPredictionTimes: (NSArray*) predictions
{
	NSMutableString* minutes = [NSMutableString string];
	
	for (Prediction* prediction in predictions) {
		if ([minutes length] != 0) {
			[minutes appendString: @", "];
		}
		if (prediction.minutes != 0) {
			[minutes appendFormat: @"%d", prediction.minutes];
		}
	}
	
	return minutes;
}

- (void) predictionRequest: (PredictionRequest*) predictionRequest didSucceedWithPredictions: (NSArray*) predictions
{
	if (predictionRequest == _homePredictionRequest)
	{
		_toOfficeStatusLabel.text = [self formatPredictionTimes: predictions];
		return;
	}

	// For the office stop we need to wait for both the office and the humber loop stop
	
	if (predictionRequest == _officePredictionRequest) {
		_officePredictions = [predictions retain];
	}
	
	if (predictionRequest == _humberLoopPredictionRequest) {
		_humberLoopPredictions = [predictions retain];
	}
	
	if (_officePredictions != nil && _humberLoopPredictions != nil)
	{
		// Now only take vehicles from the office stop that go past humber loop
		
		NSMutableArray* interestingPredictions = [NSMutableArray array];
		
		for (Prediction* p1 in _officePredictions) {
			for (Prediction* p2 in _humberLoopPredictions) {
				if ([p1.vehicle isEqualToString: p2.vehicle]) {
					[interestingPredictions addObject: p1];
				}
			}
		}

		_toHomeStatusLabel.text = [self formatPredictionTimes: interestingPredictions];
	}
}

- (void) viewDidAppear:(BOOL)animated
{
	// To the office from home
	_homePredictionRequest = [[PredictionRequest alloc] initWithAgency: kAgency route: kRoute stop: kHomeStop delegate: self];
	
	// To home from the office. Needs to predictions because the NextBus API does not deal well with the 501 to Long Branch.
	_officePredictionRequest = [[PredictionRequest alloc] initWithAgency: kAgency route: kRoute stop: kOfficeStop delegate: self];
	_humberLoopPredictionRequest = [[PredictionRequest alloc] initWithAgency: kAgency route: kRoute stop: kHumberLoopStop delegate: self];
}

@end
