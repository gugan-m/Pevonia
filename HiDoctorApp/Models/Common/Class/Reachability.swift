//
//  Reachability.swift
//   HiDoctorApp
//
//  Created by Vignaya on 01/4/16.
//  Copyright © 2016 swaas. All rights reserved.
//


import SystemConfiguration

import Foundation

public let ReachabilityChangedNotification = "ReachabilityChangedNotification"

   func callback(_ reachability:SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) {
    //let reachability = Unmanaged<Reachability>.fromOpaque(OpaquePointer(info)).takeUnretainedValue()
    let reachability = Unmanaged<Reachability>.fromOpaque(info!).takeUnretainedValue()
    DispatchQueue.main.async() {
        reachability.reachabilityChanged(flags: flags)
    }
}


public class Reachability: NSObject {
    
    public typealias NetworkReachable = (Reachability) -> ()
    public typealias NetworkUnreachable = (Reachability) -> ()
    
    public enum NetworkStatus: CustomStringConvertible {
        
        case NotReachable, ReachableViaWiFi, ReachableViaWWAN
        
        public var description: String {
            switch self {
            case .ReachableViaWWAN:
                return "Cellular"
            case .ReachableViaWiFi:
                return "WiFi"
            case .NotReachable:
                return "No Connection"
            }
        }
    }
    
    // MARK: - *** Public properties ***
    
    public var whenReachable: NetworkReachable?
    public var whenUnreachable: NetworkUnreachable?
    public var reachableOnWWAN: Bool
    public var notificationCenter = NotificationCenter.default
    
    public var currentReachabilityStatus: NetworkStatus {
        if isReachable() {
            if isReachableViaWiFi() {
                return .ReachableViaWiFi
            }
            if isRunningOnDevice {
                return .ReachableViaWWAN
            }
        }
        
        return .NotReachable
    }
    
    public var currentReachabilityString: String {
        return "\(currentReachabilityStatus)"
    }
    
    // MARK: - *** Initialisation methods ***
    
    required public init?(reachabilityRef: SCNetworkReachability?) {
        reachableOnWWAN = true
        self.reachabilityRef = reachabilityRef
    }
    
    public convenience init?(hostname: String) {
        
        let nodename = (hostname as NSString).utf8String
        let ref = SCNetworkReachabilityCreateWithName(nil, nodename!)
        self.init(reachabilityRef: ref)
    }
    
    public class func reachabilityForInternetConnection() -> Reachability? {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let ref = withUnsafePointer(to: &zeroAddress)
        {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }
        return Reachability(reachabilityRef: ref)
    }
    
    public class func reachabilityForLocalWiFi() -> Reachability? {
        
        var localWifiAddress: sockaddr_in = sockaddr_in(sin_len: __uint8_t(0), sin_family: sa_family_t(0), sin_port: in_port_t(0), sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        localWifiAddress.sin_len = UInt8(MemoryLayout.size(ofValue: localWifiAddress))
        localWifiAddress.sin_family = sa_family_t(AF_INET)
        
        // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
        let address: UInt32 = 0xA9FE0000
        localWifiAddress.sin_addr.s_addr = in_addr_t(address.bigEndian)
        
        let ref = withUnsafePointer(to: &localWifiAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
            }
        }
        return Reachability(reachabilityRef: ref)
    }
    
    // MARK: - *** Notifier methods ***
    public func startNotifier() -> Bool {
        getAppDelegate().startUpdatingLocations()
        if notifierRunning { return true }
        
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = Unmanaged.passUnretained(self).toOpaque()
        if SCNetworkReachabilitySetCallback(reachabilityRef!, callback, &context)  {
            if SCNetworkReachabilitySetDispatchQueue(reachabilityRef!, reachabilitySerialQueue) {
                notifierRunning = true
                return true
            }
        }
        
        stopNotifier()
        
        return false
    }
    
    
    public func stopNotifier() {
        if let reachabilityRef = reachabilityRef {
            currentLat = EMPTY
            currentLong = EMPTY
            SCNetworkReachabilitySetCallback(reachabilityRef, nil, nil)
            SCNetworkReachabilitySetDispatchQueue(reachabilityRef, nil)
        }
        
        notifierRunning = false
    }
    
    // MARK: - *** Connection test methods ***
    public func isReachable() -> Bool {
        return isReachableWithTest(test: { (flags: SCNetworkReachabilityFlags) -> (Bool) in
            return self.isReachableWithFlags(flags: flags)
        })
    }
    
    public func isReachableViaWWAN() -> Bool {
        
        if isRunningOnDevice {
            return isReachableWithTest() { flags -> Bool in
                // Check we're REACHABLE
                if self.isReachable(flags: flags) {
                    
                    // Now, check we're on WWAN
                    if self.isOnWWAN(flags: flags) {
                        return true
                    }
                }
                return false
            }
        }
        return false
    }
    
    public func isReachableViaWiFi() -> Bool {
        
        return isReachableWithTest() { flags -> Bool in
            
            // Check we're reachable
            if self.isReachable(flags: flags) {
                
                if self.isRunningOnDevice {
                    // Check we're NOT on WWAN
                    if self.isOnWWAN(flags: flags) {
                        return false
                    }
                }
                return true
            }
            
            return false
        }
    }
    
    // MARK: - *** Private methods ***
    private var isRunningOnDevice: Bool = {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return false
            #else
            return true
        #endif
        }()
    
    private var notifierRunning = false
    private var reachabilityRef: SCNetworkReachability?
    //private let reachabilitySerialQueue = dispatch_queue_create("uk.co.ashleymills.reachability", DISPATCH_QUEUE_SERIAL)
    private let reachabilitySerialQueue = DispatchQueue(label: "uk.co.ashleymills.reachability",attributes: [])
       func reachabilityChanged(flags: SCNetworkReachabilityFlags) {
        if isReachableWithFlags(flags: flags) {
            if let block = whenReachable {
                block(self)
            }
        } else {
            if let block = whenUnreachable {
                block(self)
            }
        }
        
        notificationCenter.post(name: NSNotification.Name(rawValue: ReachabilityChangedNotification), object:self)
    }
    
    private func isReachableWithFlags(flags: SCNetworkReachabilityFlags) -> Bool {
        
        let reachable = isReachable(flags: flags)
        
        if !reachable {
            return false
        }
        
        if isConnectionRequiredOrTransient(flags: flags) {
            return false
        }
        
        if isRunningOnDevice {
            if isOnWWAN(flags: flags) && !reachableOnWWAN {
                // We don't want to connect when on 3G.
                return false
            }
        }
        
        return true
    }
    
    private func isReachableWithTest(test: (SCNetworkReachabilityFlags) -> (Bool)) -> Bool {
        
        if let reachabilityRef = reachabilityRef {
            
            var flags = SCNetworkReachabilityFlags(rawValue: 0)
            let gotFlags = withUnsafeMutablePointer(to: &flags) {
                SCNetworkReachabilityGetFlags(reachabilityRef, UnsafeMutablePointer($0))
            }
            
            if gotFlags {
                return test(flags)
            }
        }
        
        return false
    }
    
    // WWAN may be available, but not active until a connection has been established.
    // WiFi may require a connection for VPN on Demand.
    private func isConnectionRequired() -> Bool {
        return connectionRequired()
    }
    
    private func connectionRequired() -> Bool {
        return isReachableWithTest(test: { (flags: SCNetworkReachabilityFlags) -> (Bool) in
            return self.isConnectionRequired(flags: flags)
        })
    }
    
    // Dynamic, on demand connection?
    private func isConnectionOnDemand() -> Bool {
        return isReachableWithTest(test: { (flags: SCNetworkReachabilityFlags) -> (Bool) in
            return self.isConnectionRequired(flags: flags) && self.isConnectionOnTrafficOrDemand(flags: flags)
        })
    }
    
    // Is user intervention required?
    private func isInterventionRequired() -> Bool {
        return isReachableWithTest(test: { (flags: SCNetworkReachabilityFlags) -> (Bool) in
            return self.isConnectionRequired(flags: flags) && self.isInterventionRequired(flags: flags)
        })
    }
    
    private func isOnWWAN(flags: SCNetworkReachabilityFlags) -> Bool {
        #if os(iOS)
            return flags.contains(.isWWAN)
            #else
            return false
        #endif
    }
    private func isReachable(flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.reachable)
    }
    private func isConnectionRequired(flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.connectionRequired)
    }
    private func isInterventionRequired(flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.interventionRequired)
    }
    private func isConnectionOnTraffic(flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.connectionOnTraffic)
    }
    private func isConnectionOnDemand(flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.connectionOnDemand)
    }
    func isConnectionOnTrafficOrDemand(flags: SCNetworkReachabilityFlags) -> Bool {
        return !flags.intersection([.connectionOnTraffic, .connectionOnDemand]).isEmpty
    }
    private func isTransientConnection(flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.transientConnection)
    }
    private func isLocalAddress(flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.isLocalAddress)
    }
    private func isDirect(flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.isDirect)
    }
    private func isConnectionRequiredOrTransient(flags: SCNetworkReachabilityFlags) -> Bool {
        let testcase:SCNetworkReachabilityFlags = [.connectionRequired, .transientConnection]
        return flags.intersection(testcase) == testcase
    }
    
    private var reachabilityFlags: SCNetworkReachabilityFlags {
        if let reachabilityRef = reachabilityRef {
            
            var flags = SCNetworkReachabilityFlags(rawValue: 0)
            let gotFlags = withUnsafeMutablePointer(to: &flags) {
                SCNetworkReachabilityGetFlags(reachabilityRef, UnsafeMutablePointer($0))
            }
            
            if gotFlags {
                return flags
            }
        }
        
        return []
    }
    
    override public var description: String {
        
        var W: String
        if isRunningOnDevice {
            W = isOnWWAN(flags: reachabilityFlags) ? "W" : "-"
        } else {
            W = "X"
        }
        let R = isReachable(flags: reachabilityFlags) ? "R" : "-"
        let c = isConnectionRequired(flags: reachabilityFlags) ? "c" : "-"
        let t = isTransientConnection(flags: reachabilityFlags) ? "t" : "-"
        let i = isInterventionRequired(flags: reachabilityFlags) ? "i" : "-"
        let C = isConnectionOnTraffic(flags: reachabilityFlags) ? "C" : "-"
        let D = isConnectionOnDemand(flags: reachabilityFlags) ? "D" : "-"
        let l = isLocalAddress(flags: reachabilityFlags) ? "l" : "-"
        let d = isDirect(flags: reachabilityFlags) ? "d" : "-"
        
        return "\(W)\(R) \(c)\(t)\(i)\(C)\(D)\(l)\(d)"
    }
    
    deinit {
        stopNotifier()
        
        reachabilityRef = nil
        whenReachable = nil
        whenUnreachable = nil
    }
}
