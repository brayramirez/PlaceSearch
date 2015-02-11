//
//  Bookmark.h
//  PlaceSearch
//
//  Created by Braymon Ramirez on 2/11/15.
//  Copyright (c) 2015 Braymon Ramirez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Bookmark : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * vicinity;

@end
