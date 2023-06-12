//
//  CustomPriceButton.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 11.06.2023.
//

import UIKit

final class PriceButtom: UIButton {
    func addTargetToButtonForAnimation() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }

    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6))
    }

    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }

    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: .curveEaseInOut,
                       animations: {
                        button.transform = transform
            }, completion: nil)
    }
}
