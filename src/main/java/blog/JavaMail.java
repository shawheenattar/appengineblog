package blog;

import javax.activation.DataHandler;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;
import java.util.logging.Logger;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

import java.util.regex.Matcher; 
import java.util.regex.Pattern; 

public class JavaMail {

	private static final Logger _logger = Logger.getLogger(GAEJCronServlet.class.getName());
	
	private static Set<String> getEmails() {
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Key blogKey = KeyFactory.createKey("Blog", "Space");
		
		Query query = new Query("Subscribed-Email", blogKey).addSort("email", Query.SortDirection.DESCENDING);
		List<Entity> emailList = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
		
		Set<String> emailListOut = new HashSet<String>();
		for (Entity email : emailList) {		
			emailListOut.add((String) email.getProperty("email"));
		}
		
		return emailListOut;
	}

	public static void sendDailyDigest(String from, String subject, String text) 
			throws MessagingException, IOException {
				
		Set<String> recipients = getEmails();

		final String username = "shawheen14@gmail.com";
		final String password = "rzxqvhzjwytbfotd";

		Properties prop = System.getProperties();
		prop.put("mail.smtp.host", "smtp.gmail.com");
		prop.put("mail.smtp.port", "587");
		prop.put("mail.smtp.auth", "true");
		prop.put("mail.smtp.starttls.enable", "true");

		Session session = Session.getInstance(prop, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});

		try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(String.join(",", recipients))
            );
            message.setSubject("The News From a Galaxy Far Far Away");
//            message.setText(text);
            message.setContent(
                    "<h1>Episode X</h1><p><a href='https://sinuous-studio-268122.appspot.com/unsubscribe.html'>Unsubscribe</a></p>",
                   "text/html");

            Transport.send(message);

            _logger.info("Email Sent");

        } catch (MessagingException e) {
            e.printStackTrace();
        }

	}

}
