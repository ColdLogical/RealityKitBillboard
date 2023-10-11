import ARKit
import RealityKit
import SwiftUI

public struct BillboardSystem: System {

    static let query = EntityQuery(
        where: .has(
            BillboardComponent.self
        )
    )
    
    public init(scene: RealityKit.Scene) {
        setUpSession()
    }
    
    #if os(visionOS)
    private let arkitSession = ARKitSession()
    private let worldTrackingProvider = WorldTrackingProvider()

    func setUpSession() {
        Task {
            do {
                try await arkitSession.run([
                    worldTrackingProvider
                ])
            } catch {
                print("Error: \(error)")
            }
        }
    }
    #endif
    
    #if os(iOS)
    public static var arView: ARView?
    func setUpSession() {
        // DO NOTHING
    }
    #endif

    public func update(context: SceneUpdateContext) {
        let entities = context
            .scene
            .performQuery(Self.query)
            .map({
                $0
            })

        guard entities.isEmpty == false
        else {
            return
        }
        
        var cameraTransform: Transform = Transform()
        
        #if os(xrOS)
        if let deviceAnchor = worldTrackingProvider.queryDeviceAnchor(
            atTimestamp: CACurrentMediaTime()
        ) {
            let originFromAnchor = deviceAnchor.originFromAnchorTransform
            cameraTransform = Transform(
                matrix: originFromAnchor
            )
        }
        #endif
        
        #if os(iOS)
        if let arView = BillboardSystem.arView {
            cameraTransform = arView.cameraTransform
        }
        #endif
        
        for entity in entities {
            entity.setOrientation(cameraTransform.rotation, relativeTo: nil)
        }
    }
}
