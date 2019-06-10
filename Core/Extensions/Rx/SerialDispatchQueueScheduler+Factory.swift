//
//  SerialDispatchQueueScheduler+Factory.swift
//  Core
//
//  Created by Serge Maslyakov on 02/04/2019.
//  Copyright © 2019 serge.maslyakov@gmail.com. All rights reserved.
//

import Foundation
import RxSwift

public typealias SerialRxScheduler = SerialDispatchQueueScheduler

public extension SerialDispatchQueueScheduler {

    static var sharedBackground: SerialDispatchQueueScheduler = {
        return makeSerialBackgroundScheduler("\(AppBundle.bundleIdentifier).background.shared.serial.scheduler")
    }()

    static func makeSerialBackgroundScheduler(_ label: String = "background_serial_scheduler") -> SerialDispatchQueueScheduler {
        return SerialDispatchQueueScheduler(internalSerialQueueName: label)
    }

}
