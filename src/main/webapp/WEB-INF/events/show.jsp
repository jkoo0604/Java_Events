<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Event Detail</title>
<link href="/webjars/bootstrap/4.5.0/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="/css/style.css">
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
	  <a class="navbar-brand" href="#">Events</a>
	  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
	    <span class="navbar-toggler-icon"></span>
	  </button>
	  <div class="collapse navbar-collapse" id="navbarNavDropdown">
	    <ul class="navbar-nav mr-auto">
	      <li class="nav-item active">
	        <a class="nav-link" href="/events">Home</a>
	      </li>
	      <li class="nav-item dropdown">
	        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
	          Your Events
	        </a>
	        <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
	          <a class="dropdown-item" href="/user/host">Hosted Events</a>
	          <a class="dropdown-item" href="/user/attend">Attended Events</a>
	        </div>
	      </li>
	    </ul>
	    <span class="navbar-text">
	      <a href="/logout">Logout</a>
	    </span>
	  </div>
	</nav>
	<div class="container">
		<div class="row">
			<div class="col">
				<h3>${event.name }</h3>
			</div>
		</div>
		<div class="row padding"></div>
		<div class="row">
			<div class="col-6">
				<div class="row">
					<div class="col">
						<p>Host: ${event.host.firstName } ${event.host.lastName }</p>
						<p>Date: <fmt:formatDate value="${event.eventDate}" type="BOTH" timeZone="America/Los_Angeles" dateStyle="long" timeStyle="long"/></p>
						<p>Location: ${event.location } ${event.state }</p>
						<p># Attending: ${fn:length(event.attendees)}</p>
					</div>
				</div>
				<div class="row padding"></div>
				<div class="row">
					<div class="col">
						<table class="table table-striped">
						<thead class="thead-dark">
						    <tr>
						      <th scope="col">Name</th>
						      <th scope="col">Location</th>
						    </tr>
						</thead>
						<tbody>
						  	<c:forEach items="${event.attendees}" var="e">
						    <tr>
						      <th scope="row"><c:out value="${e.firstName} ${e.lastName }"/></th>
						      <td><c:out value="${e.location}"/></td>
						    </tr>
						    </c:forEach>
						</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="col-6">
				<div class="row">
					<div class="col">
						<h5>Message Wall</h5>
					</div>
				</div>
				<div class="row padding"></div>
				<div class="row">
					<div class="col">
						<div class="messages">
							<c:forEach items="${event.messages}" var="m">
						    <p class="msg">${m.poster.firstName}: ${m.text }</p>
						    <p class="msgdate"><fmt:formatDate value="${m.createdAt}" type="BOTH" timeZone="America/Los_Angeles" dateStyle="short" timeStyle="long"/></p>
						    <p class="linebr"></p>
						    </c:forEach>
						</div>
					</div>
				</div>
				<div class="row padding"></div>
				<div class="row">
					<p class="err"><c:out value="${error}" /></p>
				</div>
				<div class="row">
					<div class="col">
						<form action="/events/${event.id}/add" method="post">
							<div class="form-group">
								<div class="form-group">
								    <label for="text">Add Comment</label>
								    <textarea class="form-control" name="text"></textarea>
								</div>
							</div>
							<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
							<div>
								<input type="submit" value="Add" class="btn btn-dark btn-sm"/>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<div class="row padding"></div>
		<div class="row">
			<div class="col text-right">
				<a href="/events" class="btn btn-outline-dark btn-sm" role="button">Back</a>
			</div>
		</div>
	</div>
<script src="/webjars/jquery/3.5.1/jquery.min.js "></script>
<script src="/webjars/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="/webjars/bootstrap/4.5.0/js/bootstrap.min.js"></script>  
</body>
</html>