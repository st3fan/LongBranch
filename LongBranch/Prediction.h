//  Prediction.h

#import <Foundation/Foundation.h>

@interface Prediction : NSObject {
  @private
  	NSString* _vehicle;
	NSInteger _minutes;
}

@property (nonatomic,assign) NSInteger minutes;
@property (nonatomic,retain) NSString* vehicle;

- (void) setMinutesFromString: (NSString*) minutes;

@end
