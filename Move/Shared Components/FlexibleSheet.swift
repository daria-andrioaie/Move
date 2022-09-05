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
            .padding(45)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
            .shadow(radius: 25)
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
