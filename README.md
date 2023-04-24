# **IMPORTANT**
This is a forked version of the original Project Sloth camera. Thix version supports esx thorough ox_inventory

---

# ps-camera
The ps-camera script allows you to capture images throughout the city, serving as a tool for gathering evidence or simply snapping enjoyable photos!



# Setup

* Add items to ox_inventory > data > items.lua
```
	['camera'] = {
		label = 'Camera',
		weight = 1,
		stack = true,
		description = "",
		client = {
			export = 'ps-camera-esx.useCam'
		}
	},

	['photo'] = {
		label = 'Photo',
		weight = 1,
		stack = true,
		description = "",
		client = {
			export = 'ps-camera-esx.usePhotoPos'
		}
	},
```
* Add pictures for items to your-inventory > html > images
* Add Discord webhook to ps-camera > server > [Line 4](https://github.com/Project-Sloth/ps-camera/blob/cc0c2c35ab15840abe7533521a3ed4aac729cc60/server/sv_main.lua#L4) 

# Preview
* Camera Overlay
![image](https://user-images.githubusercontent.com/82112471/231553020-f5061241-e04a-462e-8266-a48b8efc9884.png)

* Picture Overlay
![image](https://user-images.githubusercontent.com/82112471/231553182-fd15c5f7-b908-42f7-a8d6-93185fd6e3c2.png)
