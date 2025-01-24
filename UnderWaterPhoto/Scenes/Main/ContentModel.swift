//
//  MainModel.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 19.10.2023.
//

import Foundation
import UIKit

struct ContentModel: Identifiable, Equatable, Comparable {
	var id: String
	var defaultid: String?
	var defaultImage: UIImage?
	var alphaSetting: Float?
	var image: UIImage?
	var url: String?
	var selected: Bool = false
	
	static func < (lhs: ContentModel, rhs: ContentModel) -> Bool {
		return lhs.id == rhs.id
		&& lhs.defaultid == rhs.defaultid
		&& lhs.defaultImage == rhs.defaultImage
		&& lhs.alphaSetting == rhs.alphaSetting
		&& lhs.image == rhs.image
		&& lhs.url == rhs.url
		&& lhs.selected == rhs.selected
	}
}
