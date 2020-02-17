package blog;

import java.io.IOException;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import java.util.*;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import org.jsoup.*;
import org.jsoup.helper.*;
import org.jsoup.nodes.*;
import org.jsoup.select.*;

@SuppressWarnings("serial")

public class GAEJCronServlet extends HttpServlet {

	private static final Logger _logger = Logger.getLogger(GAEJCronServlet.class.getName());
	public final static long MILLIS_PER_DAY = 24 * 60 * 60 * 1000L;

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		try {
			_logger.info("Cron Job has been executed");
			// Put your logic here

			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

			String blogName = "Space";
			Key blogKey = KeyFactory.createKey("Blog", blogName);

			Query query = new Query("Greeting", blogKey);
			List<Entity> blogList = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
			List<Entity> newPosts = new ArrayList<Entity>();

			for (Entity blog : blogList) {
				String title = (String) blog.getProperty("title");
				_logger.info(title);
				Date date = (Date) blog.getProperty("date");
				Date now = new Date();

				if (Math.abs(now.getTime() - date.getTime()) <= MILLIS_PER_DAY) {
					newPosts.add(blog);
					_logger.info("blog added");
				}
			}
			
			

			Document doc = Document.createShell("");

			Element headline = doc.body().appendElement("h1").text("Daily Digest");

			for (Entity blog : newPosts) {
				String title = (String) blog.getProperty("title");
				User userObj = (User) blog.getProperty("user");
				String user = userObj.getNickname();
				Date dateObj = (Date) blog.getProperty("date");
				String date = dateObj.toString();
				String content = (String) blog.getProperty("content");

				if (blog.getProperty("user") == null) {
					user = "Anonymous";
				} 
				doc.body().appendElement("h3").text(title);
				doc.body().appendElement("h4").text(user);
				doc.body().appendElement("h4").text(date);
				doc.body().appendElement("p").text(content);
				
			}
			Element unsub = doc.body().appendElement("p").text("");
			unsub.prependElement("a").attr("href", "https://sinuous-studio-268122.appspot.com/unsubscribe.html").appendText("Unsubscribe");
			
			if (newPosts.size() > 0) {
				String from = "shawheen14@gmail.com";
				String subject = "subject";
				String body = doc.toString();
				JavaMail.sendDailyDigest(from, subject, body);
			}

		} catch (Exception ex) {
			// Log any exceptions in your Cron Job
			ex.printStackTrace();
			_logger.info(ex.toString());
		}
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}