//
//  BibDecoderError.m
//  BibCoding
//
//  Created by Steve Brunwasser on 2/16/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

#import "BibDecoderError.h"

NSErrorDomain const BibDecoderErrorDomain = @"brun.steve.bibliotek.coding.decoder.error";

NSErrorUserInfoKey const BibDecoderErrorKeyPathKey = @"brun.steve.bibliotek.coding.decoder.error-key.key-path";
NSErrorUserInfoKey const BibDecoderErrorInvalidDataKey = @"brun.steve.bibliotek.coding.decoder.error-key.invalid-data";
NSErrorUserInfoKey const BibDecoderErrorInvalidClassKey = @"brun.steve.bibliotek.coding.decoder.error-key.invalid-class";
NSErrorUserInfoKey const BibDecoderErrorExpectedClassKey = @"brun.steve.bibliotek.coding.decoer.error-key.expected-class";
