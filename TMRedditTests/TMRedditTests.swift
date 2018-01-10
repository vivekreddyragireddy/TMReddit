//
//  TMRedditTests.swift
//  TMRedditTests
//
//  Created by vivek on 1/10/18.
//  Copyright © 2018 vivek. All rights reserved.
//

import XCTest
@testable import TMReddit

class TMRedditTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCard() {
        let card = TMCard(title: "card1", commentNumber: "1", score: "1", imageURL: "http://www.abc.com/image/1")
        
        XCTAssertNotNil(card.title , "title can't be nil")
        XCTAssertNotNil(card.commentNumber , "title can't be nil")
        XCTAssertNotNil(card.score , "title can't be nil")
        XCTAssertNotNil(card.imageURL , "title can't be nil")
        
        XCTAssert(card.title == "card1", "title is wrongly mapped")
        XCTAssert(card.commentNumber == "1", "comment number is wrongly mapped")
        XCTAssert(card.score == "1", "score is wrongly mapped")
        XCTAssert(card.imageURL == "http://www.abc.com/image/1", "image is wrongly mapped")
    }
    
    func testCards() {
        let card1 = TMCard(title: "card1", commentNumber: "1", score: "1", imageURL: "http://www.abc.com/image/1")
        let card2 = TMCard(title: "card2", commentNumber: "2", score: "2", imageURL: "http://www.abc.com/image/2")
        let card3 = TMCard(title: "card3", commentNumber: "3", score: "3", imageURL: "http://www.abc.com/image/3")
        let card4 = TMCard(title: "card4", commentNumber: "4", score: "4", imageURL: "http://www.abc.com/image/4")
        
        let cards = [card1,card2,card3,card4]
        let cardsModel = TMCards(afterLink: "abc", cards: cards)
        
        XCTAssert(cardsModel.afterLink == "abc", "afterLink is wrongly mapped")
        XCTAssert(cardsModel.cards?.count == 4, "No of cards not matching")
    }
    
}
