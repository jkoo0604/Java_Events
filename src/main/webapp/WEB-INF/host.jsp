<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hosted Events</title>
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
	      <li class="nav-item">
	        <a class="nav-link" href="/events">Home</a>
	      </li>
	      <li class="nav-item dropdown active">
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
				<h3>${user.firstName}'s Hosted Events</h3>
			</div>
		</div>
		<div class="row padding"></div>
		<div class="row">
			<div class="col">
				<h5>Future events you are hosting:</h5>
			</div>
		</div>
		<div class="row">
			<div class="col">
				<table class="table table-striped">
				<thead class="thead-dark">
				    <tr>
				      <th scope="col">Name</th>
				      <th scope="col">Date</th>
				      <th scope="col">Location</th>
				      <th scope="col">Action / Status</th>
				    </tr>
				</thead>
				<tbody>
				  	<c:forEach items="${futureevents}" var="e">
				    <tr>
				      <th scope="row"><a href="/events/${e.id}"><c:out value="${e.name}"/></a></th>
				      <td><fmt:formatDate value="${e.eventDate}" type="BOTH" timeZone="America/Los_Angeles" dateStyle="long" timeStyle="long"/></td>
				      <td><c:out value="${e.location}"/></td>
				      <td>
			      		<ul class="list-inline">
				            <li class="list-inline-item">
				                <a href="/events/${e.id}/edit" class="btn btn-link btn-sm" role="button">Edit</a>
				            </li>
				            <li class="list-inline-item"> | </li>
				            <li class="list-inline-item">
				            	<form action="/events/${e.id}" method="post">
					  				<input type="hidden" name="_method" value="delete">
					  				<input type="submit" value="Delete" class="btn btn-link btn-sm">
								</form>
			      				<!-- <button type="button" class="btn btn-link btn-sm" data-toggle="modal" data-target="#deleteModal">Delete</button> -->
				            </li>
				        </ul>			      	
					  </td>
				    </tr>
				    </c:forEach>
				</tbody>
				</table>
			</div>
		</div>
		<div class="row padding"></div>
		<div class="row">
			<div class="col">
				<h5>Past events you have hosted:</h5>
			</div>
		</div>
		<div class="row">
			<div class="col">
				<table class="table table-striped">
				<thead class="thead-dark">
				    <tr>
				      <th scope="col">Name</th>
				      <th scope="col">Date</th>
				      <th scope="col">Location</th>
				      <th scope="col">Status</th>
				    </tr>
				</thead>
				<tbody>
				  	<c:forEach items="${pastevents}" var="e">
				    <tr>
				      <th scope="row"><a href="/events/${e.id}"><c:out value="${e.name}"/></a></th>
				      <td><fmt:formatDate value="${e.eventDate}" type="BOTH" timeZone="America/Los_Angeles" dateStyle="long" timeStyle="long"/></td>
				      <td><c:out value="${e.location}"/></td>
				      <td>Completed</td>
				    </tr>
				    </c:forEach>
				</tbody>
				</table>
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