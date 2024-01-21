//
//  Post.swift
//  MLS
//
//  Created by SeoJunYoung on 1/14/24.
//

import Foundation
import UIKit

struct Post: Codable {
    var id: UUID
    var title: String
    var date: Date
    var upCount: Int
}
