#SKAToolKit - SKAButton
SKAButton is a simple button class for Sprite Kit that mimics the usefulness of UIButton. SKAButton is in the SKAToolKit family created by the Sprite Kit Alliance to be used with Apples Sprite Kit framework.  

The Sprite Kit Alliance is happy to provide the SKAButton and SKAToolKit free of charge without any warranty or guarantee (see license below for more info). If there is a feature missing or you would like added please email Skyler at skyler@skymistdevelopment.com.

##SKAToolKit Install Instructions

###Using Cocoapods
pod 'SKAButton'
    
##Useful Methods
	//Add Targets to the button
    button.addTarget(self, selector: "buttonDoneWasTouched:", forControlEvents: .TouchUpInside)

  //Add target for multiple events
    button.addTarget(self, selector: "moreThanOneEvent:", forControlEvents: SKAControlEvent.DragEnter.union(.DragExit))

  //Set button target size independently of the button texture size
    button.setButtonTargetSize(CGSize(width: 300, height: 60))

###Edge Cases
A SKAButton can hold more than one state, but will show them in order of importance
Disabled > Highlighted > Selected > Normal

SKActions added to the button will override the texture for the state. In the example clicking the SKA button, but then disabling it will not show the disabled state, but will keep showing the SKAction until it is removed.
        
##Contact Info
If you would like to get in contact with the SKA, email us at join@spritekitalliance.com
    
##License
Copyright (c) 2015 Sprite Kit Alliance

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#Happy Clicking!


