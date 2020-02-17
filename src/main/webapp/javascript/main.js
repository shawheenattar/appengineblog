//function enterSite() {
//
//	var crawlPage = document.getElementById("crawlPage");
//	crawlPage.style.WebkitTransition = 'visibility 1s, opacity 1s';
//	crawlPage.style.opacity = '0';
//	crawlPage.style.visibility = 'hidden';
//	crawlPage.style.display = 'none';
//
//	var mainPage = document.getElementById("mainPage");
//	mainPage.style.WebkitTransition = 'visibility 1s, opacity 1s';
//	mainPage.style.opacity = '1';
//	mainPage.style.visibility = 'visible';
//}

function postToggle() {
	var newPost = document.getElementById("newPost");
	newPost.style.display = 'inline';
}

function closePost() {
	var newPost = document.getElementById("newPost");
	newPost.style.display = 'none';
}

function showAllPosts() {
	var allPosts = document.getElementById("extraPosts");
	allPosts.style.display = 'inline';
	
	var showButton = document.getElementById("showAllButton");
	showButton.style.display = 'none';
}
