package com.absa.fb.config;

import java.util.HashMap;
import java.util.Map;

import org.quartz.JobBuilder;
import org.quartz.JobDetail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.quartz.CronTriggerFactoryBean;
import org.springframework.scheduling.quartz.JobDetailFactoryBean;
import org.springframework.scheduling.quartz.MethodInvokingJobDetailFactoryBean;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;
import org.springframework.scheduling.quartz.SimpleTriggerFactoryBean;

import com.absa.fb.job.FBNotifier;

@Configuration
@ComponentScan("com.absa.fb")
public class QuartzConfiguration {
	/*@Bean
	public MethodInvokingJobDetailFactoryBean methodInvokingJobDetailFactoryBean() {
		MethodInvokingJobDetailFactoryBean obj = new MethodInvokingJobDetailFactoryBean();
		// obj.set
		obj.setTargetBeanName("jobnotifier");
		obj.setTargetMethod("executeInternal");
		return obj;
	}*/
	@Autowired
	private ApplicationContext applicationContext;

	@Bean
	public JobDetail engineJob() {
		return JobBuilder.newJob(FBNotifier.class).build();

	}

	@Bean
	public SimpleTriggerFactoryBean simpleTriggerFactoryBean() {
		SimpleTriggerFactoryBean stFactory = new SimpleTriggerFactoryBean();
		stFactory.setJobDetail(engineJob());
		stFactory.setStartDelay(3000);
		stFactory.setRepeatInterval(30000);
		stFactory.setRepeatCount(1);
		return stFactory;
	}

	/*@Bean
	public JobDetailFactoryBean jobDetailFactoryBean() {
		JobDetailFactoryBean factory = new JobDetailFactoryBean();
		factory.setJobClass(MyJobTwo.class);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("name", "RAM");
		map.put(MyJobTwo.COUNT, 1);
		factory.setJobDataAsMap(map);
		factory.setGroup("mygroup");
		factory.setName("myjob");
		return factory;
	}*/

	@Bean
	public CronTriggerFactoryBean cronTriggerFactoryBean() {
		CronTriggerFactoryBean stFactory = new CronTriggerFactoryBean();
		stFactory.setJobDetail(engineJob());
		stFactory.setStartDelay(3000);
		stFactory.setName("mytrigger");
		stFactory.setGroup("mygroup");
		stFactory.setCronExpression("0 0/1 * 1/1 * ? *");
		return stFactory;
	}

	@Bean
	public SchedulerFactoryBean schedulerFactoryBean() {
		SchedulerFactoryBean scheduler = new SchedulerFactoryBean();
		scheduler.setTriggers(simpleTriggerFactoryBean().getObject());
		AutowiringSpringBeanJobFactory jobFactory = new AutowiringSpringBeanJobFactory();
		jobFactory.setApplicationContext(applicationContext);
		scheduler.setJobFactory(jobFactory);
		return scheduler;
	}
}
