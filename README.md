# BillboardEntity

An entity abstraction that acts as a billboard for RealityKit. This works by maintaining a reference to the `ARView` and using the `cameraTransform` property to orientate the entity toward the camera.

## Example

```swift
// Create a billboard entity that will look at the camera of an ARView
let billboard = BillboardEntity(orientatedTo: arView)

// For the entity you want to face the camera, add it to the billboard entity
let box = MeshResource.generateBox(size: [1, 1, 1])
let boxEntity = ModelEntity(mesh: box)
billboard.addChild(boxEntity)

// Add the billboard entity to an anchor on the ARView
rootAnchor.addChild(billboard)
```
