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
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.TimeZone" %>

<html>
<head>
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
<script src="/javascript/main.js"></script>
</head>

<body>
	
	<header>
		<a href="blog.jsp">
			<h1>Space: the Final Frontier</h1>
			<p>Join to go where no man has gone before</p>
		</a>
	</header>

	<div id="mainPage">

		<div style="width: 100%">

			<div id="top-left">
				<%
					String blogName = "Space";
					pageContext.setAttribute("blogName", blogName);
					UserService userService = UserServiceFactory.getUserService();
					User user = userService.getCurrentUser();

					if (user != null) {
						pageContext.setAttribute("user", user);
				%>
				<p>
					Hello, ${fn:escapeXml(user.nickname)}! (You can <a
						style="color: white" href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign
						out</a>.)
				</p>

				<%
					} else {
				%>

				<p>
					Hello! <a
						style="color: white" href="<%=userService.createLoginURL(request.getRequestURI())%>">
						Sign in</a> to include your name with greetings you post.
				</p>

				<%
					}
				%>
			</div>

			<div id="top-right">

				<div id="subscribe-container">
					<p style="display: inline">Subscribe for daily spacemails:</p>
					<form action="/subscribe" method="post" style="display: inline">
						<div style="display: inline">
							<input name="email-content" type="email" />
						</div>
						<div style="display: inline">
							<input type="submit" value="Subscribe" />
						</div>
					</form>
					<input style="display: inline" type="hidden" name="blogName"
						value="${fn:escapeXml(blogName)}" />
				</div>
			</div>
			<div class="clear"></div>
		</div>
		<br>
		
		<!-- This part added while Shawheen was driving -->

		<%
			if (user == null) {

			} else {
		%>

		<div id="togglePost">
			<button onclick="postToggle()">Create Post</button>
		</div>

		<div id="newPost">
			<hr></hr>
			<br><br>
			<div style="width: 100%; text-align:center">
			<button id="closePost" onclick="closePost()">Close Draft</button>
			</div>
			<form action="/sign" method="post">
				<p id="titles">New Awesome Space Post</p>
				<p>Title:</p>
				<div>
					<textarea name="title" rows="1" cols="60"></textarea>
				</div>
				<p>Content:</p>
				<div>
					<textarea name="content" rows="10" cols="100"></textarea>
				</div>
				<div>
					<input type="submit" value="Submit Post" />
				</div>
				<input type="hidden" name="blogName"
					value="${fn:escapeXml(blogName)}" />
			</form>
		</div>
		
		<!-- This part added while Adrian was driving -->

		<%
			}
		%>

			<%
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			Key blogKey = KeyFactory.createKey("Blog", blogName);
			// Run an ancestor query to ensure we see the most up-to-date
			// view of the Greetings belonging to the selected Guestbook.
			Query query = new Query("Greeting", blogKey).addSort("date", Query.SortDirection.DESCENDING);
			List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());

			if (greetings.isEmpty()) {
		%>
			<p>'${fn:escapeXml(blogName)}' Blog has no messages.</p>

			<%
			} else {
		%>
			<hr></hr>
			<p id="titles">Space Posts:</p>

			<%
		
				for (int i = 0; i < 5; i++) {
				
					if ((i + 1) > greetings.size() ) {
						break;
					}
					
					Entity greeting = greetings.get(i);
					
					Date date = (Date) greeting.getProperty("date");
					String pattern = "hh:mm a, MM-dd-yyyy";
					SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
					
					simpleDateFormat.setTimeZone(TimeZone.getTimeZone("America/Chicago"));
					
					String newDate = simpleDateFormat.format(date);
					
					pageContext.setAttribute("greeting_content", greeting.getProperty("content"));
					pageContext.setAttribute("greeting_date", newDate);
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

			<blockquote id="postTitles"><strong>${fn:escapeXml(greeting_title)}</strong></blockquote>
			<blockquote>${fn:escapeXml(greeting_date)}</blockquote>
			<blockquote>${fn:escapeXml(greeting_content)}</blockquote>
			<br><br>

			<%
				}
			}
			
		%>

			

				<%
			if (greetings.size() > 5) {
				
				%>
				<button id="showAllButton" onclick="showAllPosts()">Show All
				Posts</button>

			<div id="extraPosts">
			<%
			
				for (int i = 5; i < greetings.size(); i++) {
					Entity greeting = greetings.get(i);
					
						Date date = (Date) greeting.getProperty("date");
						String pattern = "hh:mm a, MM-dd-yyyy";
						SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
						
						String newDate = simpleDateFormat.format(date);
						
						pageContext.setAttribute("greeting_content", greeting.getProperty("content"));
						pageContext.setAttribute("greeting_date", newDate);
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

				<blockquote id="postTitles"><strong>${fn:escapeXml(greeting_title)}</strong></blockquote>
				<blockquote>${fn:escapeXml(greeting_date)}</blockquote>
				<blockquote>${fn:escapeXml(greeting_content)}</blockquote>
				<br><br>
				
		<%
				}
			}
			
		%>
			</div>
		</div>
		
		<!-- This part added while Shawheen was driving -->
</body>
</html>