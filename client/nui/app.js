let displayPicture = false;
let tempsrc = '';

function sanitizeUrl(inputUrl) {
    let purifiedUrl = DOMPurify.sanitize(inputUrl, { ALLOWED_URI_REGEXP: /^https?:\/\//i });
    return purifiedUrl || 'about:blank';
}

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
			image = sanitizeUrl(image);
			$('.picture').css({
				'background-image': `url(${image})`,
			});
			tempsrc = image;
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
		tempsrc = '';
		$.post(`https://${GetParentResourceName()}/close`);
	}
}

function toggleflash(status)
{
	if(status)
	{
		$('#flashstatus').removeClass("off");
		$('#flashstatus').addClass("on");
	}
	else
	{
		$('#flashstatus').removeClass("on");
		$('#flashstatus').addClass("off");
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
			navigator.clipboard.writeText(sanitizeUrl(event.data.pic));
		}else if (event.data.action === 'toggleFlash') {
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

	$(document).ready(function() {
		$('#copynow').on('click', function() {
			navigator.clipboard.writeText(sanitizeUrl(tempsrc));
			$('#message').removeClass('hide').fadeIn(100);
			setTimeout(function() {
				$('#message').addClass('hide').fadeOut(100);
			}, 3000);
		});
	});
});
