<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %> 
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Event</title>
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
			<p class="err"><form:errors path="event1.*"/></p>
			<p class="err"><c:out value="${stateerr}" /></p>
			<%-- <p class="err"><c:out value="${lengtherr}" /></p> --%>
		</div>
		<div class="row">
			<form:form action="/events/${event.id }" method="post" modelAttribute="event1" class="eventform">
			<input type="hidden" name="_method" value="put">
			<form:input type="hidden" path="host.id" value="${user.id}"/>
				<div class="col-sm-7">
					<div class="form-row">
						<div class="form-group col-sm-4">
							<form:label path="name">Name:</form:label>
						</div>
						<div class="form-group col-sm-8">
			        		<form:input path="name"  class="form-control" type="text" value="${event.name }"/>
						</div>
					</div>
					<div class="form-row">
						<div class="form-group col-sm-4">
							<form:label path="eventDate">Date:</form:label>
						</div>
						<div class="form-group col-sm-8">
			        		<form:input path="eventDate"  class="form-control" type="datetime-local" value="${eventdatestr}" />
						</div>
					</div>
					<div class="form-row">
						<div class="form-group col-sm-4">
							<form:label path="location">Location:</form:label>
						</div>
						<div class="form-group col-sm-6">
			        		<form:input path="location"  class="form-control" type="text" value="${event.location }"/>
						</div>
						<div class="form-group col-sm-2">
			        		<form:select path="state" class="form-control" >
					        	<c:forEach items="${states}" var="s">
					        	<c:choose>
					        		<c:when test="${s == event.state }">
					        			<form:option value="${s}" label="${s}" selected="true"/>
					        		</c:when>
					        		<c:otherwise>
					        			<form:option value="${s}" label="${s}"/>
					        		</c:otherwise>
					        	</c:choose>
					        	</c:forEach>
					        </form:select>
						</div>
					</div>
					<div class="row form-group">
						<div class="col text-center">
							<input type="submit" value="Edit" class="btn btn-dark"/>
						</div>
					</div>
				</div>
			</form:form>
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