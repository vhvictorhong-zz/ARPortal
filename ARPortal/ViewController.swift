//
//  ViewController.swift
//  ARPortal
//
//  Created by Victor Hong on 21/12/2017.
//  Copyright © 2017 Victor Hong. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var planeDetectedLabel: UILabel!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        guard let sceneView = sender.view as? ARSCNView else {return}
        let touchLocation = sender.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if !hitTestResult.isEmpty {
            //were going to add room
            self.addPortal(hitTestResult: hitTestResult.first!)
        } else {
            //
        }
        
    }

    func addPortal(hitTestResult: ARHitTestResult) {
        
        let portalScene = SCNScene(named: "Portal.scnassets/Portal.scn")
        let portalNode = portalScene!.rootNode.childNode(withName: "Portal", recursively: false)!
        let transform = hitTestResult.worldTransform
        let planeXposition = transform.columns.3.x
        let planeYposition = transform.columns.3.y
        let planeZposition = transform.columns.3.z
        portalNode.position = SCNVector3(planeXposition, planeYposition, planeZposition)
        self.sceneView.scene.rootNode.addChildNode(portalNode)
        self.addPlane(nodeName: "roof", portalNode: portalNode, imageName: "top")
    }
    
    func addPlane(nodeName: String, portalNode: SCNNode, imageName: String) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard anchor is ARPlaneAnchor else {return}
        
        DispatchQueue.main.async {
            self.planeDetectedLabel.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.planeDetectedLabel.isHidden = true
        }
        
    }
}

