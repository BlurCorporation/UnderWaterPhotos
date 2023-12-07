//
//  BenefitsView.swift
//  UnderWaterPhoto
//
//  Created by Андрей Барсуков on 03.12.2023.
//

import Foundation
import SwiftUI

struct BenefitsView: View {
    
    @State private var screenWidth: CGFloat = 0
    @State private var benefitsHeight: CGFloat = 0
    @State var dragOffset: CGFloat = 0
    @State var activeBenefitsIndex = 0
    
    let arrayOfBenefits = ["benefits1", "benefits2", "benefits3"]
    let widthScale = 0.75
    let benefitsAspectRation = 1.5
    
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                ForEach(arrayOfBenefits.indices, id: \.self) { index in
                    VStack {
                        Image(arrayOfBenefits[index])
                    }
                    .frame(width: screenWidth * widthScale, height: benefitsHeight)
                    .shadow(radius: 12)
                    .offset(x: benefitsOffset(for: index))
                    .zIndex(-Double(index))
                    .gesture(
                        DragGesture().onChanged { value in
                            self.dragOffset = value.translation.width
                        }.onEnded { value in
                            let threshold = screenWidth * 0.2
                            withAnimation {
                                if value.translation.width < -threshold {
                                    activeBenefitsIndex = min(activeBenefitsIndex + 1, arrayOfBenefits.count - 1)
                                } else if value.translation.width > threshold {
                                    activeBenefitsIndex = max(activeBenefitsIndex - 1, 0)
                                }
                                dragOffset = 0
                            }
                        }
                    )
                }
            }
            .frame(width: 360, height: 350)
            .padding(.top, -16)
            .padding(.leading, 16)
            
            .onAppear {
                screenWidth = reader.size.width
                benefitsHeight = screenWidth * widthScale * benefitsAspectRation
            }
        }
    }
    
    func benefitsOffset(for index: Int) -> CGFloat {
        let adjustedIndex = index - activeBenefitsIndex
        
        let benefitsSpacing: CGFloat = 60
        let initialOffset = benefitsSpacing * CGFloat(adjustedIndex)
        let progress = min(abs(dragOffset)/(screenWidth/2), 1)
        let maxBenefitsMovement = benefitsSpacing
        
        if adjustedIndex < 0 {
            if dragOffset > 0 && index == activeBenefitsIndex - 1 {
                let distanceToMove = (initialOffset + screenWidth) * progress
                return -screenWidth + distanceToMove
            } else {
                return -screenWidth
            }
        } else if index > activeBenefitsIndex {
            let distanceToMove = progress * maxBenefitsMovement
            return initialOffset - (dragOffset < 0 ? distanceToMove : -distanceToMove)
        } else {
            if dragOffset < 0 {
                return dragOffset
            } else {
                let distanceToMove = maxBenefitsMovement * progress
                return initialOffset - (dragOffset < 0 ? distanceToMove : -distanceToMove)
            }
        }
    }
}
