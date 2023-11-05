//
//  HeaderView.swift
//  UnderWaterPhoto
//
//  Created by Максим Косников on 26.10.2023.
//

import SwiftUI

struct HeaderView: View {
    @StateObject var vm: MainViewModel
    var progress: CGFloat
    var userName: String
    
    @State private var isCross: Bool = false
    
    var headerBottomPadding: CGFloat {
        switch vm.state {
        case .main:
            return 62
        case .settings:
            return 82
        case .clear:
            return 62
        }
    }
    
    var body: some View {
        Color("blueDark")
            .cornerRadius(40, corners: [.bottomLeft, .bottomRight])
            .padding([.bottom], headerBottomPadding)
        VStack {
            HStack {
                switch vm.state {
                case .settings:
                    SettingsNavBarView(avatarImage: vm.avatarImage,
                                       name: vm.userName,
                                       mail: vm.mail)
                default:
                    navBar
                }
                Spacer()
                CrossButtonView(isCross: isCross)
                    .onTapGesture {
                        withAnimation {
                            isCross.toggle()
                            if isCross {
                                vm.state = .settings
                                vm.ttoggle()
                            } else {
                                if vm.isEmpty() {
                                    vm.state = .clear
                                } else {
                                    vm.state = .main
                                }
                            }
                        }
                    }
            }
            .padding([.top], 49)
            .padding([.leading, .trailing], 16)
            Spacer()
            ZStack {
                addPhotoButtonView
                    .frame(alignment: .bottom)
                    .ignoresSafeArea()
                    .opacity(vm.state == .settings ? 0 : 1)
            }
        }
    }
}

private extension HeaderView {
    var navBar: some View {
        HStack {
            Text("Привет, \(userName)!")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .medium))
        }
    }
    
    var addPhotoButtonView: some View {
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
                Rectangle()
                    .frame(width: 24, height: 4)
                    .foregroundColor(Color("white"))
                    .cornerRadius(3)
                    .rotationEffect(.degrees(isCross ? -45 : 0), anchor: .center)
                    .offset(x: isCross ? 0 : 8, y: isCross ? -6 : 0)
            }
        }
    }
}
