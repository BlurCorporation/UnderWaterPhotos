//
//  HeaderView.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 26.10.2023.
//

import SwiftUI

struct HeaderView: View {
    
    var progress: CGFloat
    var userName: String
    
    @State private var isCross: Bool = false
    
    private var isCollapsed: Bool {
        progress > 0.7
    }
    
    private var balance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = " "
        
        let number = NSNumber(value: 56112.65)
        let formattedValue = formatter.string(from: number)!
        return "$\(formattedValue)"
    }
    
    var body: some View {
        Color("blueDark")
            .cornerRadius(40, corners: [.bottomLeft, .bottomRight])
            .padding([.bottom], 62)
        VStack {
            navBar
                .padding([.top], 44)
                .padding([.leading, .trailing], 16)
            Spacer()
            ZStack {
                addPhotoButtonView
                    .frame(alignment: .bottom)
                    .ignoresSafeArea()
            }
        }
    }
    
    private var navBar: some View {
        HStack {
            Text("Привет \(userName)!")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .medium))
            Spacer()
            CrossButtonView(isCross: isCross)
                .onTapGesture {
                    withAnimation {
                        isCross.toggle()
                    }
                }
        }
    }
    
    private var addPhotoButtonView: some View {
        Button(action: {
            
        }, label: {
            HStack(spacing: 16) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 40))
                    .padding([.leading], 20)
                Text("Редактировать Фото и Видео")
                    .font(.system(size: 17, weight: .semibold))
                    .padding([.trailing], 20)
            }
            .foregroundColor(Color("white"))
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(Color("blue"))
            .cornerRadius(24)
            .padding([.leading, .trailing, .bottom], 16)
            .shadow(color: .black, radius: 5)
        })
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct CrossButtonView: View {
    var isCross: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 40, height: 40)
                .foregroundColor(Color("blueDark"))
            VStack {
                Rectangle()
                    .frame(width: 24, height: 4)
                    .foregroundColor(Color("white"))
                    .cornerRadius(3)
                    .rotationEffect(.degrees(isCross ? 45 : 0), anchor: .center)
                    .offset(x: isCross ? 0 : -8, y: isCross ? 6 : 0)
                    .animation(.easeIn, value: 1)
                Rectangle()
                    .frame(width: 24, height: 4)
                    .foregroundColor(Color("white"))
                    .cornerRadius(3)
                    .rotationEffect(.degrees(isCross ? -45 : 0), anchor: .center)
                    .offset(x: isCross ? 0 : 8, y: isCross ? -6 : 0)
                    .animation(.easeInOut, value: 1)
            }
        }
    }
}
