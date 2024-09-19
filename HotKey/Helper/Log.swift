// Helper/Logger.swift

import Foundation

class Logger {
    func log(_ message: String,
             file: String = #file,
             function: String = #function,
             line: Int = #line,
             object: AnyObject? = nil) {
        let fileName = (file as NSString).lastPathComponent
        let className = object.map { String(describing: type(of: $0)) } ?? "UnknownClass"
        print("[\(fileName)] \(className).\(function) line:\(line) - \(message)")
    }
}
