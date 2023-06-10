var displayPicture = false;

function setLocation(location) {
	if (typeof location === 'string') {
		document.getElementById('location').innerHTML = location;
	} else if (typeof location === 'object') {
		let formattedLocation = `X: ${location.x.toFixed(
			2
		)}, Y: ${location.y.toFixed(2)}, Z: ${location.z.toFixed(2)}`;
		document.getElementById('location').innerHTML = formattedLocation;
	}
}

function open(image, location) {
	if (!displayPicture) {
		$('.picture-container').removeClass('hide');
		if (image) {
			$('.picture').css({
				'background-image': `url(${image})`,
			});
		} else {
			$('.picture').css({
				'background-image': `url(https://slang.net/img/slang/lg/kekl_6395.png)`,
			});
		}

		if (typeof location === 'string') {
			$('#location').text(location);
		} else {
			setLocation(location);
		}
		displayPicture = true;
	}
}

function close() {
	if (displayPicture) {
		$('.picture-container').addClass('hide');
		$('#location').html('');
		$('.picture').css({ background: '' });
		displayPicture = false;
		$.post(`https://${GetParentResourceName()}/close`);
	}
}

$(document).ready(function () {
	window.addEventListener('message', function (event) {
		if (event.data.action === 'Open') {
			open(event.data.image, event.data.location);
			document.getElementById('camera-overlay').classList.remove('hide');
		} else if (event.data.action === 'SetLocation') {
			setLocation(event.data.location);
		} else if (event.data.action === 'showOverlay') {
			document.getElementById('camera-overlay').classList.remove('hide');
		} else if (event.data.action === 'hideOverlay') {
			document.getElementById('camera-overlay').classList.add('hide');
		} else if (event.data.action === 'openPhoto') {
			open(event.data.image, event.data.location);
		} else if (event.data.action === 'SavePic') {
			navigator.clipboard.writeText(str);
		}
	});

	document.onkeydown = function (event) {
		if (event.repeat) {
			return;
		}
		switch (event.key) {
			case 'Escape':
				close();
				break;
		}
	};
});
