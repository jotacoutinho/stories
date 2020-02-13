//
//  StoriesData.swift
//  Stories
//
//  Created by João Pedro De Souza Coutinho on 10/02/20.
//  Copyright © 2020 João Pedro De Souza Coutinho. All rights reserved.
//

import Foundation

public class StoriesData {
    var storiesCollectionData: [StoriesCollectionData]?
    var storiesContentData: [StoriesContentData]?
    
    public init(collectionData: [StoriesCollectionData], storiesData: [StoriesContentData]? = nil){
        self.storiesCollectionData = collectionData
        self.storiesContentData = storiesData
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
