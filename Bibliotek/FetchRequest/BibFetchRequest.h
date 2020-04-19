//
//  BibFetchRequest.h
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/23/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bibliotek/BibConstants.h>

@class BibFetchRequest;

NS_ASSUME_NONNULL_BEGIN

/// A description of properties that can be used to find records from a database.
NS_SWIFT_NAME(FetchRequest)
@interface BibFetchRequest: NSObject <NSCopying, NSMutableCopying>

/// The semantic meaning for any keywords used in this request.
///
/// For example, @c BibFetchRequestScopeIsbn would match records whose ISBN number is found in the keywords list.
@property(nonatomic, readonly, strong) BibFetchRequestScope scope;

/// The method with which a fetch request should treat keywords.
@property(nonatomic, readonly, strong) BibFetchRequestStructure structure;

/// The location within the search scope to match keywords within a fetch request.
@property(nonatomic, readonly, strong) BibFetchRequestSearchStrategy strategy;

/// A list of keyword strings that matching records should contain.
@property(nonatomic, readonly, copy) NSArray<NSString *> *keywords;

- (instancetype)initWithKeywords:(NSArray<NSString *> *)keywords scope:(BibFetchRequestScope)scope NS_SWIFT_NAME(init(keywords:scope:));

- (instancetype)initWithKeywords:(NSArray<NSString *> *)keywords scope:(BibFetchRequestScope)scope structure:(BibFetchRequestStructure)structure strategy:(BibFetchRequestSearchStrategy)strategy NS_SWIFT_NAME(init(keywords:scope:structure:strategy:)) NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithRequest:(BibFetchRequest *)request;

@end

NS_SWIFT_NAME(MutableFetchRequest)
@interface BibMutableFetchRequest: BibFetchRequest

@property(nonatomic, readwrite, strong) BibFetchRequestScope scope;

@property(nonatomic, readwrite, strong) BibFetchRequestStructure structure;

@property(nonatomic, readwrite, strong) BibFetchRequestSearchStrategy strategy;

@property(nonatomic, readwrite, copy) NSArray<NSString *> *keywords;

@end

NS_ASSUME_NONNULL_END
