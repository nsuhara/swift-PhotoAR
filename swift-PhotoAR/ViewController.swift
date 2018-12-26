//
//  ViewController.swift
//  swift-PhotoAR
//
//  Created by nsuhara on 2018/11/26.
//  Copyright © 2018 nsuhara. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.delegate = self
        self.sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARImageTrackingConfiguration()
        if let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) {
            configuration.trackingImages = referenceImages
            configuration.maximumNumberOfTrackedImages = 1
        }
        self.sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let scenePlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            scenePlane.firstMaterial?.diffuse.contents = UIColor(red: 0, green: 0, blue: 1.0, alpha: 0.5)
            let planeNode = SCNNode(geometry: scenePlane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            
            if let scene = SCNScene(named: "art.scnassets/cat.scn") {
                if let node = scene.rootNode.childNodes.first {
                    node.eulerAngles.x = .pi / 2
                    node.eulerAngles.z = .pi
                    planeNode.addChildNode(node)
                }
            }
        }
        
        return node
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
    }
    
}
