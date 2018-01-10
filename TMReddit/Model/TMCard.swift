//
//  Data.swift
//  Reddit
//
//  Created by vivek on 1/10/18.
//  Copyright © 2018 vivek. All rights reserved.
//


/// TMCard model holds values for title,commentNumber,score,imageURL
struct TMCard {
    
    private(set) var title: String?
    private(set) var commentNumber: String?
    private(set) var score: String?
    private(set) var imageURL: String?
    
    init(title: String?,
         commentNumber: String?,
         score: String?,
         imageURL: String?) {
        
        self.title = title
        self.commentNumber = commentNumber
        self.score = score
        self.imageURL = imageURL
    }
}
