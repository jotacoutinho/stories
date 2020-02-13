//
//  StoriesCollectionViewDelegate.swift
//  Stories
//
//  Created by João Pedro De Souza Coutinho on 11/02/20.
//  Copyright © 2020 João Pedro De Souza Coutinho. All rights reserved.
//

import Foundation
import UIKit

public protocol StoriesCollectionViewDelegate: AnyObject {
    func didSelectCell(index: Int, frame: CGRect)
}
