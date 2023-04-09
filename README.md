# ps-camera
The ps-camera script allows you to capture images throughout the city, serving as a tool for gathering evidence or simply snapping enjoyable photos!

# Setup

* Add items to qb-core > shared > items.lua
```
	['camera'] 						 = {['name'] = 'camera', 			  	  		['label'] = 'Camera', 					['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'camera.png', 				['unique'] = true, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,   ['description'] = 'Camera to take pretty pictures.'},
	['photo'] 				 		 = {['name'] = 'photo', 			  	  		['label'] = 'Saved Pic', 				['weight'] = 500, 		['type'] = 'item', 		['image'] = 'photo.png', 				['unique'] = true, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,   ['description'] = 'Brand new picture saved!'},
```
* Add pictures for items to your html inventory folder. 
