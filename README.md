# ps-camera
The ps-camera script allows you to capture images throughout the city, serving as a tool for gathering evidence or simply snapping enjoyable photos!

# Setup

* Add items to qb-core > shared > items.lua
```
	['camera'] 						 = {['name'] = 'camera', 			  	  		['label'] = 'Camera', 					['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'camera.png', 				['unique'] = true, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,   ['description'] = 'Camera to take pretty pictures.'},
	['photo'] 				 		 = {['name'] = 'photo', 			  	  		['label'] = 'Saved Pic', 				['weight'] = 500, 		['type'] = 'item', 		['image'] = 'photo.png', 				['unique'] = true, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,   ['description'] = 'Brand new picture saved!'},
```
* Add pictures for items to your-inventory > html > images
* Add Discord webhook to ps-camera > server > [Line 4](https://github.com/Project-Sloth/ps-camera/blob/cc0c2c35ab15840abe7533521a3ed4aac729cc60/server/sv_main.lua#L4) 

# Preview
* Camera Overlay
![image](https://user-images.githubusercontent.com/82112471/231553020-f5061241-e04a-462e-8266-a48b8efc9884.png)

* Picture Overlay
![image](https://user-images.githubusercontent.com/82112471/231553182-fd15c5f7-b908-42f7-a8d6-93185fd6e3c2.png)
