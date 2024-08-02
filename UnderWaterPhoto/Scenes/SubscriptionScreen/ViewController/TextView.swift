//
//  TextView.swift
//  UnderWaterPhoto
//
//  Created by Андрей Барсуков on 03.12.2023.
//

import Foundation
import SwiftUI

struct TextView: View {
	@State private var rulesText = L10n.TextView.rulesText
	
	var attributedString: AttributedString {
		var attrS = AttributedString(rulesText)
		let range = attrS.range(of: L10n.TextView.AttributedString.range)!
		
		attrS[range].foregroundColor = .blue
		
		return attrS
	}
	
	var body: some View {
		Text(attributedString)
			.foregroundColor(.white)
			.font(.callout)
	}
}
