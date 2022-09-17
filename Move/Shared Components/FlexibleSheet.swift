//
//  FlexibleSheet.swift
//  Move
//
//  Created by Daria Andrioaie on 05.09.2022.
//

import SwiftUI

enum SheetDisplayMode {
    case none
    case third
    case half
}

struct FlexibleSheet<Content: View>: View {
    
    let content: () -> Content
    var sheetDisplayMode: Binding<SheetDisplayMode>
    
    init(sheetMode: Binding<SheetDisplayMode>, @ViewBuilder content: @escaping () -> Content) {
        self.sheetDisplayMode = sheetMode
        self.content = content
    }
    
    var body: some View {
        content()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .overlay(alignment: .top, content: {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 72, height: 8)
                    .foregroundColor(.accentPink)
                    .offset(y: -4)
                    .clipped()
            })
        
            .background(RoundedRectangle(cornerRadius: 25)
            .foregroundColor(.white)
            .shadow(color: Color(red: 33/255, green: 11/255, blue: 80/255, opacity: 0.15), radius: 20, x: 0, y: 0))
            .offset(y: calculateOffset())
            .animation(.spring())
            .edgesIgnoringSafeArea(.all)
    }
    
    private func calculateOffset() -> CGFloat {
        switch sheetDisplayMode.wrappedValue {
        case .none:
            return UIScreen.main.bounds.height
        case .third:
            return UIScreen.main.bounds.height * 3/4
        case .half:
            return UIScreen.main.bounds.height * 1/2

        }
    }
}

struct FlexibleSheet_Previews: PreviewProvider {
    static var previews: some View {
        FlexibleSheet(sheetMode: .constant(.none)) {
            VStack { }
        }
    }
}
