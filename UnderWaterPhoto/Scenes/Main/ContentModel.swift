//
//  MainModel.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 19.10.2023.
//

import Foundation
import UIKit

struct ContentModel: Identifiable, Equatable {
	var id: String
	var defaultid: String?
	var defaultImage: UIImage?
	var alphaSetting: Float?
	var image: UIImage
	var url: String?
}
