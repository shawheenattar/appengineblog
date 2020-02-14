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

/**
 * @author shawheen14@gmail.com
 **/
public class JavaMail {

	private static final Logger _logger = Logger.getLogger(GAEJCronServlet.class.getName());

	/**
	 * Sends an email message with attachments.
	 *
	 * @param from        email address from which the message will be sent.
	 * @param recipients  array of strings containing the recipients of the message.
	 * @param subject     subject header field.
	 * @param text        content of the message.
	 * @throws MessagingException
	 * @throws IOException
	 */
	public static void send(String from, Collection<String> recipients, String subject, String text) 
			throws MessagingException, IOException {
		
		// check for null references
		Objects.requireNonNull(from);
		Objects.requireNonNull(recipients);

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
            message.setFrom(new InternetAddress("shawheen14@gmail.com"));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse("shawheen14@gmail.com, shawheen@sbcglobal.net")
            );
            message.setSubject("Testing Gmail TLS");
            message.setText("Dear Mail Crawler,"
                    + "\n\n Please do not spam my email!");

            Transport.send(message);

            _logger.info("Email Sent");

        } catch (MessagingException e) {
            e.printStackTrace();
        }

	}

}
