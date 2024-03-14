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

function copyToClipboard(text) {
	text = text.replace(/"/g, '');
	text = text.trim();
	var textarea = document.createElement('textarea');
	textarea.value = text;
	textarea.style.position = 'absolute';
	textarea.style.left = '-9999px';
	document.body.appendChild(textarea);
	textarea.select();
	try {
	  document.execCommand('copy');
	} catch (err) {
	  console.error('Unable to copy to clipboard:', err);
	}
	document.body.removeChild(textarea);
}

function toggleflash(status)
{
	$('#flashstatus').html(status);
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
			copyToClipboard(event.data.pic);
		}
		else if (event.data.action === 'toggleFlash') {
			toggleflash(event.data.status);
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