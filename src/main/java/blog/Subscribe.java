package blog;

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

import java.io.IOException;
import java.util.*;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Subscribe extends HttpServlet {
	
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        
		String blogName = "Space";
        Key blogKey = KeyFactory.createKey("Blog", blogName);
        String content = req.getParameter("email-content");
		
		Query query = new Query("Subscribed-Email", blogKey);
		List<Entity> emailList = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
		
        boolean duplicate = false;
		for (Entity email : emailList) {
			String emailName = (String) email.getProperty("email");
			if (emailName.equals(content)) {
				duplicate = true;
			}
		}
        
        if (!duplicate) {
        	Entity greeting = new Entity("Subscribed-Email", blogKey);
            greeting.setProperty("email", content);
            greeting.setProperty("content", content);

            datastore.put(greeting);  
        }
        
        resp.sendRedirect("/blog.jsp?blogName=" + blogName);
    }
}

//This part added while Shawheen was driving