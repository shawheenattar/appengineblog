package blog;

import java.io.IOException;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import java.util.*;

@SuppressWarnings("serial")

public class GAEJCronServlet extends HttpServlet {
	
	private static final Logger _logger = Logger.getLogger(GAEJCronServlet.class.getName());

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		try {
			_logger.info("Cron Job has been executed");
			//Put your logic here
			//BEGIN
			System.out.println("Cron Job has been executed");
			List<String> list = new ArrayList<>();
			list.add("shawheen14@gmail.com");
			_logger.info("Attempting to send email");
			JavaMail.send("shawheenattar@gmail.com", list, "test", "test");
			_logger.info("email sent");
			//END
		} catch (Exception ex) {
			//Log any exceptions in your Cron Job
			_logger.info("Cron Job error");
		}
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}