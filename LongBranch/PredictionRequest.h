// PredictionRequest.h

#import <Foundation/Foundation.h>

@class ASIHTTPRequest;
@class PredictionRequest;

@protocol PredictionRequestDelegate <NSObject>
- (void) predictionRequest: (PredictionRequest*) predictionRequest didFailWithError: (NSError*) error;
- (void) predictionRequest: (PredictionRequest*) predictionRequest didSucceedWithPredictions: (NSArray*) predictions;
@end

@interface PredictionRequest : NSObject {
  @private
  	NSString* _agency;
	NSString* _route;
	NSString* _stop;
	id<PredictionRequestDelegate> _delegate;
  @private
	ASIHTTPRequest* _request;
}

@property (nonatomic,readonly) NSString* agency;
@property (nonatomic,readonly) NSString* route;
@property (nonatomic,readonly) NSString* stop;

- (id) initWithAgency: (NSString*) agency route: (NSString*) route stop: (NSString*) stop delegate: (id<PredictionRequestDelegate>) delegate;

@end