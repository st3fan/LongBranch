// Prediction.m

#import "Prediction.h"

@implementation Prediction

@synthesize minutes = _minutes;
@synthesize vehicle = _vehicle;

- (void) dealloc
{
	[_vehicle release];
	[super dealloc];
}

- (void) setMinutesFromString: (NSString*) minutes
{
	_minutes = [minutes intValue];
}

@end
