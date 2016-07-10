//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Sam on 5/29/16.
//  Copyright © 2016 Sam. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
    //Tests to confirm that the Meal initializer returns when no name or a negative rating is provided
    func testMealInitialization() {
        let potential_item = Meal(name: "Newest meal", photo: nil, rating: 5)
        XCTAssertNotNil(potential_item)
        
        let no_name = Meal(name: "", photo: nil, rating: 0)
        XCTAssertNil(no_name)
        
        let bad_rating = Meal(name: "Really bad rating", photo: nil, rating: -5)
        XCTAssertNil(bad_rating)
    }
}
