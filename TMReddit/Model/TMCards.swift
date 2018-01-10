//
//  TMCards.swift
//  TMReddit
//
//  Created by vivek on 1/10/18.
//  Copyright © 2018 vivek. All rights reserved.
//


/// TMCards has collection of cards & afterLink to fetch next set of data
struct TMCards {
    private(set) var afterLink: String?
    private(set) var cards: [TMCard]?
    
    init(afterLink: String?, cards: [TMCard]?) {
        self.afterLink = afterLink
        self.cards = cards
    }
}
