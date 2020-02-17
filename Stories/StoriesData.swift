//
//  StoriesData.swift
//  Stories
//
//  Created by João Pedro De Souza Coutinho on 10/02/20.
//  Copyright © 2020 João Pedro De Souza Coutinho. All rights reserved.
//

import Foundation

public class StoriesData {
    var stories: [String]
    var usernameLabel: String
    var userImageUrl: String
    
    public init(stories: [String], usernameLabel: String, userImageUrl: String){
        self.stories = stories
        self.usernameLabel = usernameLabel
        self.userImageUrl = userImageUrl
    }
}

public class StoriesCollectionData {
    var imageUrl: String
    var label: String
    
    public init(imageUrl: String, label: String) {
        self.imageUrl = imageUrl
        self.label = label
    }
}

public class StoriesContentData {
    var imageUrl: String
    
    public init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
}
