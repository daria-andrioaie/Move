//
//  ErrorHandler.swift
//  Move
//
//  Created by Daria Andrioaie on 05.09.2022.
//

import Foundation
import SwiftMessages

struct ErrorData {
    let messsage: String
}

enum MessageType {
    case info
    case success
    case warning
    case error
    
    var theme: Theme {
        switch self {
        case .info:
            return Theme.info
        case .success:
            return Theme.success
        case .warning:
            return Theme.warning
        case .error:
            return Theme.error
        }
    }
}

class SwiftMessagesErrorHandler {
    func handle(message: String, type: MessageType = .info) {
        let errorView = MessageView.viewFromNib(layout: .cardView)
        var config = SwiftMessages.Config()
        
        errorView.configureTheme(type.theme)
        errorView.button?.isHidden = true
        errorView.configureDropShadow()
        errorView.configureContent(title: "Oops!", body: message)
        errorView.tapHandler = { _ in SwiftMessages.hide() }
        
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true)
        
        SwiftMessages.show(config: config, view: errorView)
    }
    
    func handle(error: ErrorData, type: MessageType = .info) {
        handle(message: error.messsage, type: type)
    }
}
