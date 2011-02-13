//  PredictionRequest.m

#import "XMLDigester.h"
#import "XMLDigesterObjectCreateRule.h"

#import "Prediction.h"
#import "PredictionRequest.h"
#import "ASIHTTPRequest.h"

@implementation PredictionRequest

@synthesize agency = _agency;
@synthesize stop = _stop;
@synthesize route = _route;

- (id) initWithAgency: (NSString*) agency route: (NSString*) route stop: (NSString*) stop delegate: (id<PredictionRequestDelegate>) delegate
{
	if ((self = [super init]) != nil)
	{
		_agency = [agency retain];
		_stop = [stop retain];
		_route = [route retain];
		_delegate = delegate;
	
		NSString* url = [NSString stringWithFormat:
			@"http://webservices.nextbus.com/service/publicXMLFeed?command=%@&a=%@&r=%@&s=%@",
				@"predictions", _agency, _route, _stop];

		_request = [[ASIHTTPRequest requestWithURL: [NSURL URLWithString: url]] retain];
   		[_request setDelegate: self];
   		[_request startAsynchronous];
	}
	
	return self;
}

- (void) dealloc
{
	[_agency release];
	[_request release];
	[super dealloc];
}

#pragma mark -

- (void)requestFinished: (ASIHTTPRequest*) request
{
	if (request.responseStatusCode != 200) {
		[_delegate predictionRequest: self didFailWithError: nil];
		return;
	}
	
    XMLDigester* digester = [XMLDigester digesterWithData: [request responseData]];

	[digester addRule:
		[XMLDigesterObjectCreateRule objectCreateRuleWithClass: [NSMutableArray class]]
			forPattern: @"body/predictions"];

	[digester addRule:
		[XMLDigesterObjectCreateRule objectCreateRuleWithClass: [Prediction class]]
			forPattern: @"body/predictions/direction/prediction"];

	[digester addRule:
		[XMLDigesterCallMethodWithAttributeRule callMethodWithAttributeRuleWithSelector: @selector(setMinutesFromString:) attribute: @"minutes"]
			forPattern: @"body/predictions/direction/prediction"];

	[digester addRule:
		[XMLDigesterCallMethodWithAttributeRule callMethodWithAttributeRuleWithSelector: @selector(setVehicle:) attribute: @"vehicle"]
			forPattern: @"body/predictions/direction/prediction"];

	[digester addRule:
		[XMLDigesterSetNextRule setNextRuleWithSelector: @selector(addObject:)]
			forPattern: @"body/predictions/direction/prediction"];
	
	NSMutableArray* predictions = [digester digest];
	
	[_delegate predictionRequest: self didSucceedWithPredictions: predictions];
}
 
- (void)requestFailed: (ASIHTTPRequest*) request
{
	[_delegate predictionRequest: self didFailWithError: request.error];
}

@end
