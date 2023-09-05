import RealityKit

import Combine

public class BillboardEntity: Entity {
    var arView: ARView {
        didSet {
            subscribeToUpdates(of: arView.scene)
        }
    }
    private var sceneObserver: Cancellable!
    
    // MARK: - Initializers
    required init() {
        fatalError("\(#function): BillboardEntity requires an ARView. Use init(orientatedTo:)")
    }
    
    public init(orientatedTo arView: ARView) {
        self.arView = arView
        super.init()
        
        subscribeToUpdates(of: arView.scene)
    }
    
    
    // MARK: - Operational
    fileprivate func subscribeToUpdates(of scene: Scene) {
        sceneObserver = scene.subscribe(to: SceneEvents.Update.self) {
            [unowned self] _ in
            self.orientateToCamera()
        }
    }
    
    fileprivate func orientateToCamera() {
        guard parent != nil
        else {
            return
        }
        
        let camTransform = arView.cameraTransform
        setOrientation(camTransform.rotation, relativeTo: nil)
    }
}
