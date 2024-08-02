//
//  MainModel.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 19.10.2023.
//

import Foundation
import UIKit

struct ContentModel: Identifiable, Equatable {
	var id: UUID
	var image: UIImage
	var url: String?
}
