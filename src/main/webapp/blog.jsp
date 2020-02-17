<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html>
<head>
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
</head>

<body>

	<header>
		<h1>Space: the Final Frontier</h1>
		<h2>Join to go where no man has gone before</h2>
	</header>

	<%
		String blogName = "Space";
	%>

	<div id="subscribe-container">
		<h2>Enter your email to get the Daily Digest!</h2>
		<form action="/subscribe" method="post">
			<div>
				<input name="email-content" type="email" />
			</div>
			<div>
				<input type="submit" value="Subscribe" />
			</div>
		</form>
		<input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}" />
	</div>

	<%
		pageContext.setAttribute("blogName", blogName);
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

		if (user != null) {
			pageContext.setAttribute("user", user);
	%>
	<div id="mainPage">
	<p>
		Hello, ${fn:escapeXml(user.nickname)}! (You can <a
			href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign
			out</a>.)
	</p>

	<%
		} else {
	%>

	<p>
		Hello! <a
			href="<%=userService.createLoginURL(request.getRequestURI())%>">
			Sign in</a> to include your name with greetings you post.
	</p>

	<%
		}

    	if (user == null) {
    	
    	} else {
	%>

    <form action="/sign" method="post">
      <hr></hr>
      <p id="titles">New Awesome Space Post</p>
      <p>Title:</p>
      <div><textarea name="title" rows="1" cols="60"></textarea></div>
      <p>Content:</p>
      <div><textarea name="content" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="Submit Post"/></div>
      <input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}"/>
    </form>
   
	<%
 	   }
	%>
	
	<%
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Key blogKey = KeyFactory.createKey("Blog", blogName);
		// Run an ancestor query to ensure we see the most up-to-date
		// view of the Greetings belonging to the selected Guestbook.
		Query query = new Query("Greeting", blogKey).addSort("user", Query.SortDirection.DESCENDING).addSort("date",
				Query.SortDirection.DESCENDING);
		List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());

		if (greetings.isEmpty()) {
	%>
	<p>Blog '${fn:escapeXml(blogName)}' has no messages.</p>

	<%
		} else {
	%>
	
	<hr></hr>
	<p id="titles">Space Posts:</p>

	<%
		for (Entity greeting : greetings) {
				pageContext.setAttribute("greeting_content", greeting.getProperty("content"));
				 pageContext.setAttribute("greeting_date", greeting.getProperty("date"));
			        pageContext.setAttribute("greeting_title", greeting.getProperty("title"));

				if (greeting.getProperty("user") == null) {
	%>

	<p>An anonymous person wrote:</p>

	<%
		} else {
					pageContext.setAttribute("greeting_user", greeting.getProperty("user"));
					
	%>

	<p>
		<b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:
	</p>

	<%
		}
	%>

	<blockquote id="postTitles">Post Title: ${fn:escapeXml(greeting_title)}</blockquote>
	<blockquote>Content: ${fn:escapeXml(greeting_content)}</blockquote>
	<blockquote>On: ${fn:escapeXml(greeting_date)}</blockquote>

	<%
		}
		}
	%>
	</div>
</body>
</html>