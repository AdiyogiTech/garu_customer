//
// Copyright (c) 2022 HERE Global B.V. and its affiliate(s).
// All rights reserved.
//
// This software and other materials contain proprietary information
// controlled by HERE and are protected by applicable copyright legislation.
// Any use and utilization of this software and other materials and
// disclosure to any third parties is conditional upon having a separate
// agreement with HERE for the access, use, utilization or disclosure of this
// software. In the absence of such agreement, the use of the software is not
// allowed.
//

import Flutter
import heresdk

/**
 * Establishes a communication channel with flutter to allow it to create a dart HereMapController over a native MapView.
 *
 * @param viewIdentifier The flutter id of the MapView object.
 * @param binaryMessenger A flutter messenger through which the communication channel is established.
 * @param mapView The MapView object to map to the flutter viewIdentifier.
 */
public class MapViewHost: NSObject {

    private let mapView: MapView
    private var mapViewInternalPointer: UInt64 = 0

    public init(viewIdentifier viewId: Int64, binaryMessenger: FlutterBinaryMessenger, mapView: MapView) {
        self.mapView = mapView

        super.init()

        // Channel name should match with the one used by HereMapController.
        let channel = FlutterMethodChannel(
            name: "com.here.flutter/here_sdk_\(viewId)",
            binaryMessenger: binaryMessenger,
            codec: FlutterStandardMethodCodec.sharedInstance())

        weak var weakSelf: MapViewHost? = self
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            weakSelf?.onMethodCall(call, result)
        }
    }

    func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if call.method == "initialize" {
            mapViewInternalPointer = self.getMapViewInternalPointer()
            result(mapViewInternalPointer)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func getMapViewInternalPointer() -> UInt64 {
        var  ptr: UInt64 = 0
        defer {
            if ptr == 0 {
                print("Internal error when trying to initialize map view host")
            }
        }

        guard let mapViewInternalOptional = Mirror(reflecting: mapView)
                .children.filter({ $0.label == "mapViewInternal" }).first?.value else {
            return ptr
        }

        guard let mapViewInternal = Mirror(reflecting: mapViewInternalOptional)
                .children.filter({ $0.label == "some" }).first?.value else {
            return ptr
        }

        guard let cInstance = Mirror(reflecting: mapViewInternal)
                .children.filter({ $0.label == "c_instance" }).first?.value else {
            return ptr
        }

        guard let instanceAddress = cInstance as? Int64 else {
            return ptr
        }

        ptr = UInt64(instanceAddress)
        return ptr
    }
}
