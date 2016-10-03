package com.absa.fb.job;

import java.util.List;

import org.quartz.DisallowConcurrentExecution;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.QuartzJobBean;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import com.absa.fb.pojo.Subscription;
import com.absa.fb.repository.SubscriptionRepository;
import com.restfb.DefaultFacebookClient;
import com.restfb.FacebookClient;
import com.restfb.Parameter;
import com.restfb.Version;
import com.restfb.types.GraphResponse;
import com.restfb.types.send.IdMessageRecipient;
import com.restfb.types.send.Message;

@DisallowConcurrentExecution
public class FBNotifier extends QuartzJobBean {
	private static final String MESSAGE = "message";
	private static final String ME_MESSAGES = "me/messages";
	private static final String RECIPIENT = "recipient";

	@Autowired
	private SubscriptionRepository subscriptionRepository;
	
	@Override
	public void executeInternal(JobExecutionContext ctx) throws JobExecutionException {
		IdMessageRecipient recipient =null;
	    FacebookClient facebookClient = new DefaultFacebookClient(
				"EAARItObxyDwBAOfDsSmDalg7GYbj11AlyNU9VUuAZADycz5khPGLkEEYHvZA4T9zVIgNMrTPmNTG9VICVJZAXZBQzzB3zWzlvPw9uH8NBbOOYUgYZBTAZB0K2Xl3ZC5O2kZAfzJ6DICPoJL65mj9Mk1CI1Tmiz3KMJUGWfGqZBT158AZDZD",
				"bbfcc95658d0e5d74c646893c2b241a9", Version.VERSION_2_6);
		List<Subscription> subscribers=subscriptionRepository.findAll();
		for(Subscription sub:subscribers) {
			recipient = new IdMessageRecipient(sub.getUserId());
			System.out.println("Scheduler invoked");
			Message simpleTextMessage = new Message("second Message");
			try {
				facebookClient.publish(ME_MESSAGES, GraphResponse.class, Parameter.with(RECIPIENT, recipient),
						Parameter.with(MESSAGE, simpleTextMessage));
			} catch (Throwable th) {

				th.printStackTrace();

			}
			
		}

	}

}
