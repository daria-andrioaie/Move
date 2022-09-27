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

struct GrabberView: View {
    var body: some View {
        Rectangle()
            .fill(Color.accentPink)
            .roundedCorners(radius: 30, corners: [.bottomLeft, .bottomRight])
            .frame(width: 72, height: 8)
            .offset(y: -4)
            .clipped()
    }
}

struct FlexibleSheet<Content: View>: View {
    
    @State private var verticalTranslation: CGFloat = 0
    
    let content: () -> Content
    @Binding var sheetDisplayMode: SheetDisplayMode
    var minimumVerticalDrag: CGFloat
    
    
    init(sheetMode: Binding<SheetDisplayMode>, minimumVerticalDrag: CGFloat = 100, @ViewBuilder content: @escaping () -> Content) {
        self._sheetDisplayMode = sheetMode
        self.minimumVerticalDrag = minimumVerticalDrag
        self.content = content
    }
    
    var body: some View {
        content()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .overlay(alignment: .top, content: {
                GrabberView()
            })
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(.white)
                    .shadow(color: Color(red: 33/255, green: 11/255, blue: 80/255, opacity: 0.15), radius: 20, x: 0, y: 0)
            )
            .offset(y: self.calculateOffset() + verticalTranslation)
            .gesture(dragGesture)
//            .transition(.move(edge: .bottom))
//            .animation(.linear(duration: 1), value: verticalTranslation)
            .zIndex(1)
            .animation(.easeInOut, value: verticalTranslation)
            .ignoresSafeArea(.container, edges: .bottom)
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onChanged({ value in
                let draggedHeight = value.translation.height
                guard draggedHeight > 0 else {
                    return
                }
                verticalTranslation = draggedHeight
                
            })
            .onEnded{ value in
                if value.translation.height > minimumVerticalDrag {
                    withAnimation {
                        sheetDisplayMode = .none
                    }
                }
                else {
                    withAnimation {
                        verticalTranslation = 0
                    }
                }
            }
    }
    
    private func calculateOffset() -> CGFloat {
        switch sheetDisplayMode {
        case .none:
            return UIScreen.main.bounds.height
        case .third:
            return UIScreen.main.bounds.height * 3/4 - 45
        case .half:
            return UIScreen.main.bounds.height * 1/2 - 45
        }
    }
}

struct FlexibleSheet_Previews: PreviewProvider {
    static var previews: some View {
        FlexibleSheet(sheetMode: .constant(.third)) {
            VStack { Color.blue }
        }
    }
}
