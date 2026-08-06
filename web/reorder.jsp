<%-- 
    Document   : reorder
    Created on : 1 Aug 2026, 2:17:48 am
    Author     : aarya Thorat
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.inventory.model.inventory"%>

<html>
<head>
    <title>Reorder Alert</title>
</head>

<body>

<h2>Low Stock Reorder Alert</h2>

<table border="1">

<tr>
    <th>Product ID</th>
    <th>Product Name</th>
    <th>Current Quantity</th>
    <th>Safety Stock</th>
    <th>Reorder Quantity</th>
</tr>


<%
    List<inventory> list = 
    (List<inventory>) request.getAttribute("reorderList");

    if(list != null && !list.isEmpty()) {

        for(inventory item : list) {
%>

<tr>
    <td><%= item.getItemId() %></td>
    <td><%= item.getItemName() %></td>
    <td><%= item.getQuantity() %></td>
    <td><%= item.getSafetyStock() %></td>
    <td><%= item.getReorderLevel() %></td>
</tr>

<%
        }

    } else {
%>

<tr>
    <td colspan="5">
        No products need reorder
    </td>
</tr>

<%
    }
%>


</table>

</body>
</html>
