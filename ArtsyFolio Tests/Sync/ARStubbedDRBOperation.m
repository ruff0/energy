#import "ARStubbedDRBOperation.h"
#import "ARDispatchManager.h"


@implementation ARStubbedDRBOperation

- (void)enqueueOperationForObject:(id)object dispatchGroup:(dispatch_group_t)group
{
    dispatch_group_enter(group);
    NSOperation *operation = [self.provider operationTree:self
        operationForObject:object
        continuation:^(id result, void (^completion)()) {
                                                 ar_dispatch_main_queue( ^{
                                                     [self sendObject:result completion:^{

                                                         // call the completion block associated with this node
                                                         if (completion) completion();

                                                         dispatch_group_leave(group);
                                                     }];
                                                 });
        }
        failure:^{
                                                      dispatch_group_leave(group);
        }];
    [operation start];
}

- (void)enqueueOperationsForObject:(id)object completion:(void (^)())completion
{
    [self.provider operationTree:self objectsForObject:object completion:^(NSArray *objects) {
        dispatch_group_t group = dispatch_group_create();

        for (id object in objects) {
            [self enqueueOperationForObject:object dispatchGroup:group];
        }

        dispatch_group_wait(group, 1);
        completion();

    }];
}

@end
