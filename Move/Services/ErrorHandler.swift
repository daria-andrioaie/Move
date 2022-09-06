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
    func handle(message: String, type: MessageType = .error) {
        let errorView = MessageView.viewFromNib(layout: .cardView)
        var config = SwiftMessages.Config()
        
        //TODO: configure the colors based on the type of the message
        errorView.configureTheme(backgroundColor: UIColor(red: 229.0/255.0, green: 48.0/255.0, blue: 98.0/255.0, alpha: 1.0), foregroundColor: .white)

        errorView.button?.isHidden = true
        errorView.configureDropShadow()
        errorView.configureContent(title: "Oops!", body: message)
        errorView.tapHandler = { _ in SwiftMessages.hide() }
        
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true)
        
        SwiftMessages.show(config: config, view: errorView)
    }
    
    func handle(message: String, buttonLabel: String, type: MessageType = .error, onScreenDuration: TimeInterval = 3, action: @escaping () -> Void) {
        let errorView = MessageView.viewFromNib(layout: .cardView)
        var config = SwiftMessages.Config()
        
        //TODO: configure the colors based on the type of the message
        errorView.configureTheme(backgroundColor: UIColor(red: 229.0/255.0, green: 48.0/255.0, blue: 98.0/255.0, alpha: 1.0), foregroundColor: .white)

        errorView.configureDropShadow()
        errorView.configureContent(title: "Oops!", body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: buttonLabel) { button in
            action()
        }

        errorView.tapHandler = { _ in SwiftMessages.hide() }
        
        config.duration = .seconds(seconds: onScreenDuration)
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true)
        
        SwiftMessages.show(config: config, view: errorView)
    }
    
    func handle(error: ErrorData, type: MessageType = .error) {
        handle(message: error.messsage, type: type)
    }
}
