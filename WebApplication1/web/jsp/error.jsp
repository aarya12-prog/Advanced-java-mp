<%-- 
    Document   : error.jsp
    Created on : 03-Aug-2026, 7:30:21 pm
    Author     : dines
--%>

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 40px;
        }

        .container {
            max-width: 600px;
            margin: auto;
            background: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        h1 {
            color: #d9534f;
        }

        p {
            color: #555;
            font-size: 16px;
        }

        .message {
            margin-top: 20px;
            padding: 15px;
            background-color: #f8d7da;
            color: #721c24;
            border-radius: 5px;
            border: 1px solid #f5c6cb;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: white;
            background-color: #007bff;
            padding: 10px 20px;
            border-radius: 5px;
        }

        a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Oops! Something went wrong.</h1>

    <div class="message">
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
                out.println(error);
            } else {
                out.println("An unexpected error occurred.");
            }
        %>
    </div>

    <a href="<%= request.getContextPath() %>/">Go to Home</a>
</div>

</body>
</html>

