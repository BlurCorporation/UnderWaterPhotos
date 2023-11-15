//
//  ViewControllerSubscription.swift
//  UnderWaterPhoto
//
//  Created by Андрей Барсуков on 20.09.2023.
//

import SwiftUI
import UIKit
import ScalingHeaderScrollView

protocol SubscriptionViewControllerProtocol: UIViewController {
    
}

struct SubscriptionView: View {
    
    @StateObject private var viewModel = SubscriptionViewModel()
    @State private var screenWidth: CGFloat = 0
    @State private var benefitsHeight: CGFloat = 0
    
    @State var dragOffset: CGFloat = 0
    @State var activeBenefitsIndex = 0
    
    let arrayOfBenefits = ["benefits1", "benefits2", "benefits3"]
    let widthScale = 0.75
    let benefitsAspectRation = 1.5
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    VStack {
                        ScalingHeaderScrollView {
                            Color(UIColor(.blue))
                                .cornerRadius(40)
                            VStack {
                                Spacer()
                            }
                        } content: {
                            scrollContent
                                .padding()
                        }
                        .hideScrollIndicators()
                        .height(min: 188)
                        .ignoresSafeArea()
                    }
                }
                .background(Color.blue)
                .cornerRadius(30)
                .ignoresSafeArea()
                
                
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
                                DragGesture().onChanged{ value in
                                    self.dragOffset = value.translation.width
                                }.onEnded{ value in
                                    let threshold = screenWidth * 0.2
                                    withAnimation {
                                        if value.translation.width < -threshold {
                                            activeBenefitsIndex = min(activeBenefitsIndex + 1, arrayOfBenefits.count - 1)
                                        } else if value.translation.width > threshold {
                                            activeBenefitsIndex = max(activeBenefitsIndex - 1, 0)
                                        }
                                    }
                                    withAnimation {
                                        dragOffset = 0
                                    }
                                }
                            )
                        }
                    }
                    .frame(width: 360, height: 350)
                    .padding(.top, -126)
                    .padding(.leading, 16)

                    .onAppear {
                        screenWidth = reader.size.width
                        benefitsHeight = screenWidth * widthScale * benefitsAspectRation
                    }
            }
                
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(1..<4) { index in
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 160, height: 200)
                                .cornerRadius(16)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                Text("Oформляя подписку вы соглашаетесь на  и  ")
                    .foregroundColor(.white)
                    .font(.title3)
                
                Spacer()
                
                Button(action: {
                    // action
                }) {
                    Text("Оформить")
                        .frame(maxWidth: 344, maxHeight: 55)
                        .foregroundColor(.brown)
                        .background(Color.white)
                        .padding(.bottom, 1)
                        .cornerRadius(16)
                }

            }
            .navigationBarHidden(true) // Скрыть стандартную навигационную строку
            .background(Color.brown)
        }
    }
    
    private var scrollContent: some View {
        LazyVStack {
            ForEach(0..<100) { _ in
                HStack {
                    Image("emptyImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Image("emptyImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
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






final class SubscriptionViewController: UIViewController {
    
    private var swiftUIViewController: UIHostingController<SubscriptionView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        addSwiftUIViewToViewController()
    }
    
    func addSwiftUIViewToViewController() {
        let swiftUIViewController = UIHostingController(rootView: SubscriptionView())
        self.addChild(swiftUIViewController)
        swiftUIViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(swiftUIViewController.view)
        swiftUIViewController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            swiftUIViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            swiftUIViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1),
            swiftUIViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swiftUIViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        self.swiftUIViewController = swiftUIViewController
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}


