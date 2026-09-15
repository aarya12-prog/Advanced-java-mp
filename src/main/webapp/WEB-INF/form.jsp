<%-- 
    Document   : form
    Created on : 31 Jul 2026, 9:34:59 pm
    Author     : mruna
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty hardware ? 'Add' : 'Edit'} Hardware | Inventory</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

    <!-- HEADER -->
    <header class="header">
        <div class="logo">
            HARDWARE<span>Inventory</span>
        </div>
        <nav class="nav-links">
            <a href="hardware">Dashboard</a>
            <a href="hardware?action=new" class="active">${empty hardware ? 'Add New' : 'Edit'}</a>
        </nav>
    </header>

    <!-- MAIN CONTENT -->
    <div class="container">

        <!-- PAGE TITLE -->
        <h1 class="page-title">${empty hardware ? 'Add New Hardware' : 'Edit Hardware'}</h1>

        <!-- FORM CARD -->
        <div class="card" style="max-width: 700px; margin: 0 auto;">
            <form action="hardware" method="post">
                
                <!-- Hidden fields -->
                <c:if test="${not empty hardware}">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${hardware.id}">
                </c:if>
                <c:if test="${empty hardware}">
                    <input type="hidden" name="action" value="insert">
                </c:if>

                <!-- Hardware Name -->
                <div class="form-group">
                    <label for="hardwareName">Hardware Name *</label>
                    <input type="text" id="hardwareName" name="hardwareName" 
                           class="form-control" required
                           placeholder="e.g., Dell Optiplex Desktop"
                           value="${hardware.hardwareName}">
                </div>

                <!-- Category -->
                <div class="form-group">
                    <label for="category">Category *</label>
                    <select id="category" name="category" class="form-control" required>
                        <option value="">-- Select Category --</option>
                        <option value="Computer" ${hardware.category == 'Computer' ? 'selected' : ''}>Computer</option>
                        <option value="Laptop" ${hardware.category == 'Laptop' ? 'selected' : ''}>Laptop</option>
                        <option value="Printer" ${hardware.category == 'Printer' ? 'selected' : ''}>Printer</option>
                        <option value="Networking" ${hardware.category == 'Networking' ? 'selected' : ''}>Networking</option>
                        <option value="Storage Device" ${hardware.category == 'Storage Device' ? 'selected' : ''}>Storage Device</option>
                        <option value="Monitor" ${hardware.category == 'Monitor' ? 'selected' : ''}>Monitor</option>
                        <option value="Keyboard & Mouse" ${hardware.category == 'Keyboard & Mouse' ? 'selected' : ''}>Keyboard & Mouse</option>
                        <option value="Cable & Connector" ${hardware.category == 'Cable & Connector' ? 'selected' : ''}>Cable & Connector</option>
                        <option value="Power Supply" ${hardware.category == 'Power Supply' ? 'selected' : ''}>Power Supply</option>
                        <option value="Server Equipment" ${hardware.category == 'Server Equipment' ? 'selected' : ''}>Server Equipment</option>
                        <option value="Other" ${hardware.category == 'Other' ? 'selected' : ''}>Other</option>
                    </select>
                </div>

                <!-- Brand & Model (side by side) -->
                <div style="display: flex; gap: 20px;">
                    <div class="form-group" style="flex: 1;">
                        <label for="brand">Brand</label>
                        <input type="text" id="brand" name="brand" class="form-control"
                               placeholder="e.g., Dell, HP"
                               value="${hardware.brand}">
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label for="modelNumber">Model Number</label>
                        <input type="text" id="modelNumber" name="modelNumber" class="form-control"
                               placeholder="e.g., OptiPlex 7090"
                               value="${hardware.modelNumber}">
                    </div>
                </div>

                <!-- Serial Number -->
                <div class="form-group">
                    <label for="serialNumber">Serial Number *</label>
                    <input type="text" id="serialNumber" name="serialNumber" class="form-control" required
                           placeholder="e.g., SN-DELL-001"
                           value="${hardware.serialNumber}">
                </div>

                <!-- Quantity & Price (side by side) -->
                <div style="display: flex; gap: 20px;">
                    <div class="form-group" style="flex: 1;">
                        <label for="quantity">Quantity *</label>
                        <input type="number" id="quantity" name="quantity" class="form-control" 
                               required min="0"
                               value="${empty hardware ? '1' : hardware.quantity}">
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label for="unitPrice">Unit Price (₹) *</label>
                        <input type="number" id="unitPrice" name="unitPrice" class="form-control" 
                               required min="0" step="0.01"
                               placeholder="0.00"
                               value="${hardware.unitPrice}">
                    </div>
                </div>

                <!-- Purchase Date & Warranty (side by side) -->
                <div style="display: flex; gap: 20px;">
                    <div class="form-group" style="flex: 1;">
                        <label for="purchaseDate">Purchase Date</label>
                        <input type="date" id="purchaseDate" name="purchaseDate" class="form-control"
                               value="${hardware.purchaseDate}">
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label for="warrantyExpiry">Warranty Expiry</label>
                        <input type="date" id="warrantyExpiry" name="warrantyExpiry" class="form-control"
                               value="${hardware.warrantyExpiry}">
                    </div>
                </div>

                <!-- Status -->
                <div class="form-group">
                    <label for="status">Status *</label>
                    <select id="status" name="status" class="form-control" required>
                        <option value="Available" ${hardware.status == 'Available' ? 'selected' : ''}>Available</option>
                        <option value="In Use" ${hardware.status == 'In Use' ? 'selected' : ''}>In Use</option>
                        <option value="Under Repair" ${hardware.status == 'Under Repair' ? 'selected' : ''}>Under Repair</option>
                        <option value="Retired" ${hardware.status == 'Retired' ? 'selected' : ''}>Retired</option>
                    </select>
                </div>

                <!-- Location & Assigned To (side by side) -->
                <div style="display: flex; gap: 20px;">
                    <div class="form-group" style="flex: 1;">
                        <label for="location">Location</label>
                        <input type="text" id="location" name="location" class="form-control"
                               placeholder="e.g., Room A-101"
                               value="${hardware.location}">
                    </div>
                    <div class="form-group" style="flex: 1;">
                        <label for="assignedTo">Assigned To</label>
                        <input type="text" id="assignedTo" name="assignedTo" class="form-control"
                               placeholder="e.g., John Doe"
                               value="${hardware.assignedTo}">
                    </div>
                </div>

                <!-- Supplier -->
                <div class="form-group">
                    <label for="supplierName">Supplier</label>
                    <input type="text" id="supplierName" name="supplierName" class="form-control"
                           placeholder="Supplier/Vendor name"
                           value="${hardware.supplierName}">
                </div>

                <!-- Description -->
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" class="form-control" 
                              rows="3" placeholder="Additional details...">${hardware.description}</textarea>
                </div>

                <!-- Notes -->
                <div class="form-group">
                    <label for="notes">Notes</label>
                    <textarea id="notes" name="notes" class="form-control" 
                              rows="2" placeholder="Internal notes...">${hardware.notes}</textarea>
                </div>

                <!-- Buttons -->
                <div style="display: flex; gap: 15px; margin-top: 25px; padding-top: 20px; border-top: 1px solid #e0e0e0;">
                    <button type="submit" class="btn btn-primary">
                        ${empty hardware ? 'Save Hardware' : 'Update Hardware'}
                    </button>
                    <a href="hardware" class="btn btn-secondary">Cancel</a>
                </div>

            </form>
        </div>

    </div>

    <!-- FOOTER -->
    <footer class="footer">
        &copy; 2026 Hardware Inventory Management System. All rights reserved.
    </footer>

</body>
</html>