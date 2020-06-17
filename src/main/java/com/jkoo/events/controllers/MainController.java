package com.jkoo.events.controllers;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.jkoo.events.models.Event;
import com.jkoo.events.models.User;
import com.jkoo.events.services.MainService;
import com.jkoo.events.validator.UserValidator;

@Controller
public class MainController {
	@Autowired
	private MainService mService;
	@Autowired
	private UserValidator uValidator;
	
	@RequestMapping("/")
	public String index(HttpSession session, Model model, @ModelAttribute("user") User user) {		
		
		if (session.getAttribute("userID") == null) {
			List<String> states = Arrays.asList("AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY");
			model.addAttribute("states", states);
			return "index.jsp";
		}
		Long userID = (Long) session.getAttribute("userID");
		User loggedin = mService.getUser(userID);
		if (loggedin == null) {		
			return "redirect:/logout";
		}
		return "redirect:/events";
	}
	
	@RequestMapping(value="/login", method=RequestMethod.POST)
	public String loginUser(@RequestParam("logemail") String email, @RequestParam("logpassword") String password, @Valid @ModelAttribute("user") User user, BindingResult result, Model model, HttpSession session) {
		boolean auth = mService.authenticateUser(email, password);
		if (auth) {
			User loggedin = mService.findByEmail(email);
			session.setAttribute("userID", loggedin.getId());
			return "redirect:/events";
		}
		model.addAttribute("loginerr", "Login failed. Please verify email and password.");
		List<String> states = Arrays.asList("AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY");
		model.addAttribute("states", states);
		return "index.jsp";
	}
	
	@RequestMapping(value="/registration", method=RequestMethod.POST)
	public String registerUser(@Valid @ModelAttribute("user") User user, BindingResult result, HttpSession session, Model model) {
		uValidator.validate(user, result);
		boolean dupeEmail = mService.duplicateEmail(user.getEmail());
		boolean validState = mService.checkState(user.getState());
		if (dupeEmail) {
			model.addAttribute("emailerr", "An account already exists for this email");
		}	
		if (validState == false) {
			model.addAttribute("stateerr", "Invalid state");
		}
		if (result.hasErrors() || dupeEmail || validState==false) {
			List<String> states = Arrays.asList("AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY");
			model.addAttribute("states", states);
			return "index.jsp";
		}
		User newuser = mService.registerUser(user);
		session.setAttribute("userID", newuser.getId());
		return "redirect:/events";
	}
	
	@RequestMapping("/events")
	public String home(HttpSession session, Model model, @ModelAttribute("event") Event event) {
		if (session.getAttribute("userID") == null) {
			return "redirect:/";
		}
		Long userID = (Long) session.getAttribute("userID");
		User loggedin = mService.getUser(userID);
		if (loggedin == null) {
			return "redirect:/logout";
		}
		List<String> states = Arrays.asList("AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY");
		model.addAttribute("states", states);
		List<Event> futureEvents = mService.getFutureEvents();
		model.addAttribute("events", futureEvents);
		model.addAttribute("user", loggedin);
		return "/events/welcome.jsp";
	}
	
	@RequestMapping(value="/events", method=RequestMethod.POST)
	public String createEvent(@Valid @ModelAttribute("event") Event event, BindingResult result, Model model, HttpSession session) {
		if (session.getAttribute("userID") == null) {
			return "redirect:/";
		}
		Long userID = (Long) session.getAttribute("userID");
		User loggedin = mService.getUser(userID);
		if (loggedin == null) {
			return "redirect:/logout";
		}
		if (!loggedin.getId().equals(event.getHost().getId())) {
			return "redirect:/events";
		}
		boolean validState = mService.checkState(event.getState());
		if (validState == false) {
			model.addAttribute("stateerr", "Invalid state");
		}
		if (result.hasErrors() || validState==false) {
			System.out.println(result.getAllErrors().toString());
			List<String> states = Arrays.asList("AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY");
			model.addAttribute("states", states);
			List<Event> futureEvents = mService.getFutureEvents();
			model.addAttribute("events", futureEvents);
			model.addAttribute("user", loggedin);
			return "/events/welcome.jsp";
		}
		Event newE = mService.createEvent(event);
		mService.joinEvent(newE.getId(), userID);
		return "/events/" + newE.getId();
	}
	
	@RequestMapping("/events/{id}")
	public String showEvent(Model model, HttpSession session, @PathVariable("id") Long id) {
		if (session.getAttribute("userID") == null) {
			return "redirect:/";
		}
		Long userID = (Long) session.getAttribute("userID");
		User loggedin = mService.getUser(userID);
		if (loggedin == null) {
			return "redirect:/logout";
		}
		Event event = mService.getEvent(id);
		if (event == null) {
			return "redirect:/events";
		}
		model.addAttribute("event", event);
		return "/events/show.jsp";
	}
	
	@RequestMapping(value="/events/{id}/add", method=RequestMethod.POST)
	public String createMessage(Model model, @RequestParam("text") String text, HttpSession session, @PathVariable("id") Long id) {
		if (session.getAttribute("userID") == null) {
			return "redirect:/";
		}
		Long userID = (Long) session.getAttribute("userID");
		User loggedin = mService.getUser(userID);
		if (loggedin == null) {
			return "redirect:/logout";
		}
		Event event = mService.getEvent(id);
		if (event == null) {
			return "redirect:/events";
		}
		if (text.length() < 2) {
			model.addAttribute("event", event);
			model.addAttribute("error", "Message must be at least 2 characters in length");
			return "/events/show.jsp";
		}
		mService.createMessage(text, loggedin, event);
		return "redirect:/events/" + event.getId();
	}
	
	@RequestMapping("/events/{id}/edit")
	public String editEvent(Model model, HttpSession session, @PathVariable("id") Long id, @ModelAttribute("event1") Event event) {
		if (session.getAttribute("userID") == null) {
			return "redirect:/";
		}
		Long userID = (Long) session.getAttribute("userID");
		User loggedin = mService.getUser(userID);
		if (loggedin == null) {
			return "redirect:/logout";
		}
		Event e = mService.getEvent(id);
		if (e == null) {
			return "redirect:/events";
		}
		if (!e.getHost().getId().equals(loggedin.getId())) {
			return "redirect:/events/" + id;
		}
		SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
		String eventdt = dt.format(e.getEventDate());
		model.addAttribute("eventdatestr", eventdt);
		List<String> states = Arrays.asList("AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY");
		model.addAttribute("states", states);
		model.addAttribute("user", loggedin);
		model.addAttribute("event", e);
		return "/events/edit.jsp";
		
	}
	
	@RequestMapping(value="/events/{id}", method=RequestMethod.PUT)
	public String updateEvent(@PathVariable("id") Long id, Model model, HttpSession session, @Valid @ModelAttribute("event1") Event event, BindingResult result) {
		if (session.getAttribute("userID") == null) {
			return "redirect:/";
		}
		Long userID = (Long) session.getAttribute("userID");
		User loggedin = mService.getUser(userID);
		if (loggedin == null) {
			return "redirect:/logout";
		}
		Event e = mService.getEvent(id);
		if (e == null) {
			return "redirect:/events";
		}
		if (!loggedin.getId().equals(event.getHost().getId()) || !e.getId().equals(event.getId())) {
			return "redirect:/events/" + id;
		}
		boolean validState = mService.checkState(event.getState());
		if (validState == false) {
			model.addAttribute("stateerr", "Invalid state");
		}
		if (result.hasErrors() || validState==false) {
			System.out.println(result.getAllErrors().toString());
			model.addAttribute("lengtherr","Name and location must be at least 2 characters in length");
			SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
			String eventdt = dt.format(e.getEventDate());
			model.addAttribute("eventdatestr", eventdt);
			model.addAttribute("user", loggedin);
			List<String> states = Arrays.asList("AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY");
			model.addAttribute("states", states);
			model.addAttribute("event", e);
			return "/events/edit.jsp";
		}
		mService.updateEvent(event);
		return "/events/" + id;
	}
	
	@RequestMapping(value="/events/{id}", method=RequestMethod.DELETE)
	public String deleteEvent(@PathVariable("id") Long id, Model model, HttpSession session) {
		
		if (session.getAttribute("userID") == null) {
			return "redirect:/";
		}
		Long userID = (Long) session.getAttribute("userID");
		User loggedin = mService.getUser(userID);
		if (loggedin == null) {
			return "redirect:/logout";
		}
		Event e = mService.getEvent(id);
		if (e.equals(null)) {
			return "redirect:/events";
		}
		if (!loggedin.getId().equals(e.getHost().getId())) {
			return "redirect:/events/" + id;
		}
		mService.removeEvent(id);
		return "redirect:/events";
	}
	
	@RequestMapping(value="/events/{id}/join", method=RequestMethod.PUT)
	public String joinEvent(@PathVariable("id") Long eventID, Model model, HttpSession session) {
		if (session.getAttribute("userID") == null) {
			return "redirect:/";
		}
		Long userID = (Long) session.getAttribute("userID");
		User loggedin = mService.getUser(userID);
		if (loggedin == null) {
			return "redirect:/logout";
		}
		Event e = mService.getEvent(eventID);
		if (e == null) {
			return "redirect:/events";
		}
		mService.joinEvent(eventID, userID);
		return "/events/" + eventID;
	}
	
	@RequestMapping(value="/events/{id}/leave", method=RequestMethod.PUT)
	public String leaveEvent(@PathVariable("id") Long eventID, Model model, HttpSession session) {
		if (session.getAttribute("userID") == null) {
			return "redirect:/";
		}
		Long userID = (Long) session.getAttribute("userID");
		User loggedin = mService.getUser(userID);
		if (loggedin == null) {
			return "redirect:/logout";
		}
		Event e = mService.getEvent(eventID);
		if (e == null) {
			return "redirect:/events";
		}
		mService.leaveEvent(eventID, userID);
		return "/events/" + eventID;
	}
	
	@RequestMapping("/user/host")
	public String showUserHost(Model model, HttpSession session) {
		if (session.getAttribute("userID") == null) {
			return "redirect:/";
		}
		Long userID = (Long) session.getAttribute("userID");
		User loggedin = mService.getUser(userID);
		if (loggedin == null) {
			return "redirect:/logout";
		}
		List<Event> futureEvents = mService.getFutureEventsHosted(userID);
		model.addAttribute("futureevents", futureEvents);
		List<Event> pastEvents = mService.getPastEventsHosted(userID);
		model.addAttribute("pastevents", pastEvents);
		model.addAttribute("user", loggedin);
		return "host.jsp";		
	}
	
	@RequestMapping("/user/attend")
	public String showUserAttendee(Model model, HttpSession session) {
		if (session.getAttribute("userID") == null) {
			return "redirect:/";
		}
		Long userID = (Long) session.getAttribute("userID");
		User loggedin = mService.getUser(userID);
		if (loggedin == null) {
			return "redirect:/logout";
		}
		List<Event> futureEvents = mService.getFutureEventsAttended(userID);
		model.addAttribute("futureevents", futureEvents);
		List<Event> pastEvents = mService.getPastEventsAttended(userID);
		model.addAttribute("pastevents", pastEvents);
		model.addAttribute("user", loggedin);
		return "attendee.jsp";		
	}
	
	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}
	
	@RequestMapping(value = "/**/{[path:[^\\.]*}")
	public String allRoutes() {
		return "redirect:/";
	}
	
}
