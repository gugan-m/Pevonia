//
//  ConvenienceExtensions.swift
//  SwifterSwift
//
//  Created by Omar Albeik on 8/8/16.
//  Copyright © 2016 Omar Albeik. All rights reserved.
//

import UIKit

public class SwifterSwift {
	/// Return app current build number
	public static var appBuild: String? {
		return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
	}
	
	/// Application icon badge current number
	public static var applicationIconBadgeNumber: Int {
		get {
			return UIApplication.shared.applicationIconBadgeNumber
		}
		set {
			UIApplication.shared.applicationIconBadgeNumber = newValue
		}
	}
	
	/// Return app current version
	public static var appVersion: String? {
		return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	}
	
	/// Return current battery level
	public static var batteryLevel: Float {
		return UIDevice.current.batteryLevel
	}
    
    /// Return current battery level
    public static var batteryState: UIDeviceBatteryState {
        return UIDevice.current.batteryState
    }
	
	/// Return shared instance of current device
	public static var currentDevice: UIDevice {
		return UIDevice.current
	}
	
	/// Return device height.
	var screenHeight: CGFloat {
		return UIScreen.main.bounds.height
	}
	
	/// Return current device model
	public static var deviceModel: String {
		return UIDevice.current.model
	}
	
	/// Return current device name
	public static var deviceName: String {
		return UIDevice.current.name
	}
	
	/// Return current orientation of device
	public static var deviceOrientation: UIDeviceOrientation {
		return UIDevice.current.orientation
	}
	
	/// Return device width.
	var screenWidth: CGFloat {
		return UIScreen.main.bounds.width
	}
	
	/// Return true if app is running in debug mode
	public static var isInDebuggingMode: Bool {
		// http://stackoverflow.com/questions/9063100/xcode-ios-how-to-determine-whether-code-is-running-in-debug-release-build
		#if DEBUG
			return true
		#else
			return false
		#endif
	}
	
	/// Return true if multitasking is supported in current device
	public static var isMultitaskingSupported: Bool {
		return UIDevice.current.isMultitaskingSupported
	}
	
	/// Network activity indicator state
	public static var isNetworkActivityIndicatorVisible: Bool {
		get {
			return UIApplication.shared.isNetworkActivityIndicatorVisible
		}
		set {
			UIApplication.shared.isNetworkActivityIndicatorVisible = newValue
		}
	}
	
	/// Return true if device is iPad.
	public var isPad: Bool {
		return UIDevice.current.userInterfaceIdiom == .pad
	}
	
	/// Return true if device is iPhone.
	public var isPhone: Bool {
		return UIDevice.current.userInterfaceIdiom == .phone
	}
	
	/// Return true if device is registered for remote notifications for current app (read only)
	public static var isRegisteredForRemoteNotifications: Bool {
		return UIApplication.shared.isRegisteredForRemoteNotifications
	}
	
	/// Return true is application is running on simulator
	public static var isRunningOnSimulator: Bool {
		// http://stackoverflow.com/questions/24869481/detect-if-app-is-being-built-for-device-or-simulator-in-swift
		#if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
			return true
		#else
			return false
		#endif
	}
	
	/// Status bar visibility state
	public static var isStatusBarHidden: Bool {
		get {
			return UIApplication.shared.isStatusBarHidden
		}
		set {
			UIApplication.shared.isStatusBarHidden = newValue
		}
	}
	
	/// Return key window (read only)
	public static var keyWindow: UIView? {
		return UIApplication.shared.keyWindow
	}
	
	/// Most top view controller
	var mostTopViewController: UIViewController? {
		get {
			return UIApplication.shared.keyWindow?.rootViewController
		}
		set {
			UIApplication.shared.keyWindow?.rootViewController = newValue
		}
	}
	
	/// Get an object from UserDefaults
	public static func object(forKey: String) -> Any? {
		return UserDefaults.standard.object(forKey: forKey)
	}
	
	/// Get a string from UserDefaults
	public static func string(forKey: String) -> String? {
		return UserDefaults.standard.string(forKey: forKey)
	}
	
	/// Get an integer from UserDefaults
	public static func integer(forKey: String) -> Int? {
		return UserDefaults.standard.integer(forKey: forKey)
	}
	
	/// Get a double from UserDefaults
	public static func double(forKey: String) -> Double? {
		return UserDefaults.standard.double(forKey: forKey)
	}
	
	/// Get a data from UserDefaults
	public static func data(forKey: String) -> Data? {
		return UserDefaults.standard.data(forKey: forKey)
	}
	
	/// Get a data from UserDefaults
	public static func bool(forKey: String) -> Bool? {
		return UserDefaults.standard.bool(forKey: forKey)
	}
	
	/// Get an array from UserDefaults
	public static func array(forKey: String) -> [Any]? {
		return UserDefaults.standard.array(forKey: forKey)
	}
	
	/// Get an dictionary from UserDefaults
	public static func dictionary(forKey: String) -> [String: Any]? {
		return UserDefaults.standard.dictionary(forKey: forKey)
	}
	
	/// Get a float from UserDefaults
	public static func float(forKey: String) -> Float? {
		return UserDefaults.standard.object(forKey: forKey) as? Float
	}
	
	/// Save an object to UserDefaults
	public static func set(value: Any?, forKey: String) {
		UserDefaults.standard.set(value, forKey: forKey)
	}
	
	/// Return shared instance UIApplication
	public static var sharedApplication: UIApplication {
		return UIApplication.shared
	}
	
	/// Current status bar style
	public static var statusBarStyle: UIStatusBarStyle? {
		get {
			return UIApplication.shared.statusBarStyle
		}
		set {
			if let style = newValue {
				UIApplication.shared.statusBarStyle = style
			}
		}
	}
	
	/// Return system current version
	public static var systemVersion: String {
		return UIDevice.current.systemVersion
	}
	
	/// Return class name of object as string.
	public static func typeName(for object: Any) -> String {
		let type = Swift.type(of: object.self)
		return String.init(describing: type)
	}
	
	/// Return shared instance of standard UserDefaults
	public static var userDefaults: UserDefaults {
		return UserDefaults.standard
	}
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}
